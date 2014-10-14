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

    def inspect
      "Point <x: #{x}, y: #{y}>"
    end

    def to_share
      @x.to_s + '-' + Encoder.i_to_s(@y)
    end

    def self.from_share(share)
      x_share, y_share = share.split '-'
      Point.new(x_share.to_i, Encoder.s_to_i(y_share))
    end

    def self.to_secret_int(points)
      x_values = []
      y_values = []
      points.each do |point|
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

    def self.transpose(points)
      x_values = []
      y_values = []

      points.each do |point|
        x_values << point.x
        y_values << point.y
      end
      [x_values, y_values]
    end
  end
end
