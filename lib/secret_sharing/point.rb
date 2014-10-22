module SecretSharing
  # This class is used to store a two dimensional point consisting of integers.
  class Point
    attr_accessor :x, :y

    # Create a Point object.
    #
    # Examples
    #
    #   Point.new(1, 2)
    #   # => #<Point: @x=1 @y=2>
    #
    # @param x [Integer] The x value of the point
    # @param y [Integer] The y value of the point
    def initialize(x, y)
      unless x.is_a?(Integer) && y.is_a?(Integer)
        fail ArgumentError, 'Coordinates must be integers'
      end

      @x = x
      @y = y
    end

    # A nicer inspection of a point object than by default.
    #
    # @return [String] String representation of a Point
    #
    # Examples
    #
    #   SecretSharing::Point.new(1, 2).inspect
    #   # => "#<Point: @x=1 @y=2>"
    def inspect
      "#<Point: @x=#{x} @y=#{y}>"
    end

    def to_s
      "#{x}-#{y.to_s(16)}"
    end

    def self.from_string(point_string)
      x_string, y_string = point_string.split '-'
      Point.new x_string.to_i, y_string.to_i(16)
    end

    # An implementation similar to Array#transpose for Arrays of Points
    #
    # @return [Array] Two Arrays in an Array
    #
    # Examples
    #
    #   point1 = SecretSharing::Point.new(1, 2)
    #   point2 = SecretSharing::Point.new(3, 4)
    #   points = [point1, point2]
    #   Point.transpose(points)
    #   # => [[1, 3], [2, 4]]
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
