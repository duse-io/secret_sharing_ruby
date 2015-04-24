require 'securerandom'

module SecretSharing
  # The polynomial is used to represent the required random polynomials used in
  # Shamir's Secret Sharing algorithm.
  class Polynomial
    attr_reader :coefficients

    # Create a new instance of a Polynomial with n coefficients, when having
    # the polynomial in standard polynomial form.
    #
    # Example
    #
    #   For the polynomial f(x) = a0 + a1 * x + a2 * x^2 + ... + an * x^n the
    #   coefficients are [a0, a1, a2, ..., an]
    #
    #   Polynomial.new [1, 2, 3]
    #   # => #<SecretSharing::Polynomial:0x0000000 @coefficients=[1, 2, 3]>
    #
    # @param coefficients [Array] an array of integers as the coefficients
    def initialize(coefficients)
      coefficients.each do |c|
        not_an_int = 'One or more coefficents are not integers'
        fail ArgumentError, not_an_int unless c.is_a?(Integer)
      end
      @coefficients = coefficients
      @coefficients.freeze
    end

    # Generate points on the polynomial, that can be used to reconstruct the
    # polynomial with.
    #
    # Example
    #
    #   SecretSharing::Polynomial.new([1, 2, 3, 4]).points(3, 7)
    #   # => [#<Point: @x=1 @y=3>, #<Point: @x=2 @y=0>, #<Point: @x=3 @y=2>]
    #
    # @param num_points [Integer] number of points to generate
    # @param prime [Integer] prime for calculation in finite field
    # @return [Array] array of calculated points
    def points(num_points, prime)
      intercept = @coefficients[0] # the first coefficient is the intercept
      (1..num_points).map do |x|
        y = intercept
        (1...@coefficients.length).each do |i|
          y = (y + @coefficients[i] * x ** i) % prime
        end
        Point.new(x, y)
      end
    end

    # Generate a random polynomial with a specific degree, defined x=0 value
    # and an upper limit for the coefficients of the polynomial. All
    # coefficients generated are >= 1.
    #
    # Example
    #
    #   Polynomial.random(2, 3, 7)
    #   # => #<SecretSharing::Polynomial:0x0000000 @coefficients=[3, 0, 4]>
    #
    # @param degree [Integer] degree of the polynomial to generate
    # @param intercept [Integer] the y value for x=0
    # @param upper_bound [Integer] the highest value of a single coefficient
    def self.random(degree, intercept, upper_bound)
      fail ArgumentError, 'Degree must be a non-negative number' if degree < 0

      coefficients = (0...degree).reduce([intercept]) do |accumulator|
        accumulator << SecureRandom.random_number(upper_bound - 1) + 1
      end
      new coefficients
    end

    # Generate points from a secret integer.
    #
    # Example
    #
    #   SecretSharing::Polynomial.points_from_secret(123, 2, 3)
    #   # => [#<Point: @x=1 @y=109>, #<Point: @x=2 @y=95>, #<Point: @x=3 @y=81>]
    #
    # @param secret_int [Integer] the secret to divide into points
    # @param point_threshold [Integer] number of points to reconstruct
    # @param num_points [Integer] number of points to generate
    # @return [Polynomial] the generated polynomial
    def self.points_from_secret(secret_int, point_threshold, num_points)
      prime = Prime.large_enough_prime(secret_int)
      fail ArgumentError, 'Threshold must be at least 2' if point_threshold < 2
      fail ArgumentError, 'Threshold must be less than the total number of points' if point_threshold > num_points

      polynomial = random(point_threshold - 1, secret_int, prime)
      polynomial.points(num_points, prime)
    rescue Prime::CannotFindLargeEnoughPrime
      raise ArgumentError, 'Secret is too long'
    end

    # Modular lagrange interpolation
    def self.modular_lagrange_interpolation(points)
      _, y_values = Point.transpose(points)
      prime = Prime.large_enough_prime(y_values.max)
      points.reduce(0) do |f_x, point|
        numerator, denominator = lagrange_fraction(points, point, prime)
        lagrange_polynomial = numerator * mod_inverse(denominator, prime)
        (prime + f_x + (point.y * lagrange_polynomial)) % prime
      end
    end

    # part of the lagrange interpolation
    def self.lagrange_fraction(points, current, prime)
      numerator, denominator = 1, 1
      points.each do |point|
        if point != current
          numerator = (numerator * (0 - point.x)) % prime
          denominator = (denominator * (current.x - point.x)) % prime
        end
      end
      [numerator, denominator]
    end

    # inverse modulo
    def self.mod_inverse(k, prime)
      k = k % prime
      r = egcd(prime, k.abs)[2]
      (prime + r) % prime
    end

    # extended Euclidean algorithm
    def self.egcd(a, b)
      return [b, 0, 1] if a == 0
      g, y, x = egcd(b % a, a)
      [g, x - b.div(a) * y, y]
    end
  end
end
