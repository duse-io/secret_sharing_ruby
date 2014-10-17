module SecretSharing
  class Polynomial
    def initialize(coefficients)
      @coefficients = coefficients
    end

    def points(num_points, prime)
      (1..num_points).map do |x|
        y = @coefficients[0]
        (1..(@coefficients.length-1)).each do |i|
          exponentiation = x**i % prime
          term = (@coefficients[i] * exponentiation) % prime
          y = (y + term) % prime
        end
        Point.new(x, y)
      end
    end

    def self.random(degree, intercept, upper_bound)
      if degree < 0
        raise ArgumentError, 'Degree must be a non-negative number'
      end
      coefficients = [intercept]
      degree.times do |i|
        coefficients << Random.new.rand(0..upper_bound-1)
      end
      Polynomial.new coefficients
    end

    def self.points_from_secret(secret_int, point_threshold, num_points)
      if point_threshold < 2
        raise ArgumentError, 'Threshold must be at least 2'
      end
      if point_threshold > num_points
        raise ArgumentError, 'Threshold must be less than less than the total number of points'
      end
      prime = SecretSharing::Prime.get_large_enough_prime([secret_int, num_points])
      if not prime
        raise ArgumentError, 'Secret is too long'
      end
      polynomial = SecretSharing::Polynomial.random(point_threshold-1, secret_int, prime)
      polynomial.points(num_points, prime)
    end

    def self.modular_lagrange_interpolation(points)
      x_values, y_values = Point.transpose(points)
      prime = SecretSharing::Prime.get_large_enough_prime(y_values)
      (0...points.length).inject(0) do |f_x, i|
        numerator, denominator = 1, 1
        points.length.times do |j|
          next if i == j
          numerator = (numerator * (0 - x_values[j])) % prime
          denominator = (denominator * (x_values[i] - x_values[j])) % prime
        end
        lagrange_polynomial = numerator * mod_inverse(denominator, prime)
        f_x = (prime + f_x + (y_values[i] * lagrange_polynomial)) % prime
      end
    end

    def self.mod_inverse(k, prime)
      k = k % prime
      r = egcd(prime, k.abs)[2]
      (prime + r) % prime
    end

    def self.egcd(a, b) # extended Euclidean algorithm
      if a == 0
        return [b, 0, 1]
      end
      g, y, x = egcd(b % a, a)
      [g, x - b.div(a) * y, y]
    end
  end
end
