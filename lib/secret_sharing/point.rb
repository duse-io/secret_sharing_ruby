module SecretSharing
  class Point
    attr_accessor :x, :y
    
    def initialize(x, y)
      if not (x.is_a?(Integer) && y.is_a?(Integer))
        raise ArgumentError, 'Coordinates must be integers' 
      end

      @x = x
      @y = y
    end

    def to_share(charset)
      SecretSharing::Point.validate_charset(charset)
      String.int_to_charset(@x, charset) + '-' + String.int_to_charset(@y, charset)
    end

    def self.from_share(share, charset)
      validate_charset(charset)
      if not (share.is_a?(String) and share.count('-') == 1)
        raise ArgumentError, 'Share format is invalid'
      end

      x_share, y_share = share.split '-'

      if x_share.diff(charset) or y_share.diff(charset)
        raise ArgumentError, 'Share contains chars that are not in charset'
      end
      
      Point.new(x_share.charset_to_int(charset), y_share.charset_to_int(charset))
    end

    def self.validate_charset(charset)
      if charset.include? '-'
        raise ArgumentError, 'Charset cannot include "-"'
      end
    end

    def self.to_secret_int(points)
      if not points.is_a?(Array)
        raise ArgumentError, 'Points must be an array'
      end
      
      x_values = []
      y_values = []
      points.each do |point|
        if not point.is_a?(Point)
          raise ArgumentError, 'Array must only contain points'
        end
        
        x_values << point.x
        y_values << point.y
      end

      prime = SecretSharing::Prime.get_large_enough_prime(y_values)
      SecretSharing::Polynomial.modular_lagrange_interpolation(0, points, prime)
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
      coefficients = SecretSharing::Polynomial.random_polynomial(point_threshold-1, secret_int, prime)
      SecretSharing::Polynomial.get_polynomial_points(coefficients, num_points, prime)
    end
  end
end
