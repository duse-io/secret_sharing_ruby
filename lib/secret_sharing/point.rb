module SecretSharing
  class Point
    attr_accessor :x, :y

    def initialize(x, y)
      unless x.is_a?(Integer) && y.is_a?(Integer)
        fail ArgumentError, 'Coordinates must be integers'
      end

      @x = x
      @y = y
    end

    def inspect
      "#<Point: @x=#{x} @y=#{y}>"
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
