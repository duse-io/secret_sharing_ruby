module SecretSharing
  class Polynomial
    def initialize(coefficients)
      @coefficients = coefficients
    end

    def points(num_points, prime)
      (1..num_points).map do |x|
        y = @coefficients[0]
        (1...@coefficients.length).each do |i|
          exponentiation = x**i % prime
          term = (@coefficients[i] * exponentiation) % prime
          y = (y + term) % prime
        end
        Point.new(x, y)
      end
    end

    def self.random(degree, intercept, upper_bound)
      fail ArgumentError, 'Degree must be a non-negative number' if degree < 0

      coefficients = (0...degree).reduce([intercept]) do |accumulator, _i|
        accumulator << Random.new.rand(0...upper_bound)
      end
      Polynomial.new coefficients
    end

    def self.points_from_secret(secret_int, point_threshold, num_points)
      prime = SecretSharing::Prime.large_enough_prime([secret_int, num_points])
      fail ArgumentError, 'Secret is too long' if prime.nil?
      fail ArgumentError, 'Threshold must be at least 2' if point_threshold < 2
      fail ArgumentError, 'Threshold must be less than less than the total number of points' if point_threshold > num_points

      polynomial = SecretSharing::Polynomial.random(point_threshold - 1, secret_int, prime)
      polynomial.points(num_points, prime)
    end

    def self.modular_lagrange_interpolation(points)
      y_values = Point.transpose(points)[1]
      prime = SecretSharing::Prime.large_enough_prime(y_values)
      points.reduce(0) do |f_x, point|
        numerator, denominator = lagrange_fraction(points, point, prime)
        lagrange_polynomial = numerator * mod_inverse(denominator, prime)
        (prime + f_x + (point.y * lagrange_polynomial)) % prime
      end
    end

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

    def self.mod_inverse(k, prime)
      k = k % prime
      r = egcd(prime, k.abs)[2]
      (prime + r) % prime
    end

    def self.egcd(a, b) # extended Euclidean algorithm
      return [b, 0, 1] if a == 0
      g, y, x = egcd(b % a, a)
      [g, x - b.div(a) * y, y]
    end
  end
end
