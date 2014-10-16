module SecretSharing
  module Encoder
    def point_to_share(point)
      point.x.to_s + '-' + HexCharset.new.i_to_s(point.y)
    end

    def points_from_secret(secret_int, point_threshold, num_points)
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
      coefficients = SecretSharing::Polynomial.random_polynomial(point_threshold-1, secret_int, prime)
      SecretSharing::Polynomial.get_polynomial_points(coefficients, num_points, prime)
    end

    def encode(secret_string, share_threshold, num_shares)
      charset = Charset.new(secret_string)
      secret_int = charset.s_to_i(secret_string)
      points = points_from_secret(secret_int, share_threshold, num_shares)
      shares = []
      points.each do |point|
        shares << charset.to_s + '-' + point_to_share(point)
      end
      shares
    end

    module_function :points_from_secret,
                    :point_to_share,
                    :encode
  end
end
