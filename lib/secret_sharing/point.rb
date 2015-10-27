module SecretSharing
  # This class is used to store a two dimensional point consisting of integers.
  class Point
    # @return [Integer] x value the point was instantiated with
    attr_reader :x
    # @return [Integer] y value the point was instantiated with
    attr_reader :y

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
      @x = x
      @y = y
    end

    # Inspection of a point
    #
    # @return [String] Simple x, y representation
    #
    # Examples
    # 
    #   Point.new(1, 2).inspect
    #   # => "<SecretSharing::Point @x=1, @y=2>"
    def inspect
      "<SecretSharing::Point @x=#{x} ,@y=#{y}>"
    end

    # An implementation similar to Array#transpose for Arrays of Points
    #
    # @param points [Array<Point>] Array of points to transpose
    # @return [Array<Array<Integer>>] Two Arrays in an Array
    #
    # Examples
    #
    #   point1 = SecretSharing::Point.new(1, 2)
    #   point2 = SecretSharing::Point.new(3, 4)
    #   Point.transpose [point1, point2]
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
