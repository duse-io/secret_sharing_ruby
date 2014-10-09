module SecretSharing
  module Polynomial
    def egcd(a, b)
      if a == 0
        return [b, 0, 1]
      end
      g, y, x = egcd(b % a, a)
      [g, x - b.div(a) * y, y]
    end

    def mod_inverse(k, prime)
      k = k % prime
      r = egcd(prime, k.abs)[2]
      (prime + r) % prime
    end

    def random_polynomial(degree, intercept, upper_bound)
      if degree < 0
        raise ArgumentError, 'Degree must be a non-negative number'
      end
      coefficients = [intercept]
      degree.times do |i|
        coefficients << Random.new.rand(0..upper_bound-1)
      end
      coefficients
    end

    def get_polynomial_points(coefficients, num_points, prime)
      points = []
      (1..num_points+1).each do |x|
        y = coefficients[0]
        1..coefficients.length do |i|
          exponentiation = x**i % prime
          term = (coefficients[i] * exponentiation) % prime
          y = (y + term) % prime
        end
        points << Point.new(x, y)
      end
      points
    end

    def modular_lagrange_interpolation(x, points, prime)
      x_values, y_values = points.transpose
      f_x = 0
      points.length.times do |i|
        numerator, denominator = 1, 1
        points.length.times do |j|
          next if i == j
          numerator = (numerator * (x - x_values[j])) % prime
          denominator = (denominator * (x_values[i] - x_values[j])) % prime
        end
        lagrange_polynomial = numerator * mod_inverse(denominator, prime)
        f_x = (prime + f_x + (y_values[i] * lagrange_polynomial)) % prime
      end
      f_x
    end

    module_function :egcd, 
                    :mod_inverse,
                    :random_polynomial,
                    :get_polynomial_points,
                    :modular_lagrange_interpolation
  end
end
