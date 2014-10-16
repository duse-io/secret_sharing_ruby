module SecretSharing
  module Decoder
    def points_to_secret_int(points)
      x_values, y_values = Point.transpose(points)
      prime = SecretSharing::Prime.get_large_enough_prime(y_values)
      SecretSharing::Polynomial.modular_lagrange_interpolation(0, points, prime)
    end

    module_function :points_to_secret_int
  end
end
