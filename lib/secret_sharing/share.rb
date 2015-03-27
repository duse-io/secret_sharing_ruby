module SecretSharing
  # A share is an object that encapsulates the properties of a share created by
  # Shamir's Secret Sharing algorithm.
  class Share
    # @return [SecretSharing::Point] Point the share was instantiated with
    attr_reader :point

    # Create a share object
    #
    # Example
    #
    #   point = SecretSharing::Point.new 1, 2
    #   SecretSharing::Share.new point
    #   # => #<SecretSharing::Share:0x0000000 @point=...>
    #
    # @param point [SecretSharing::Point]
    def initialize(point)
      @point = point
    end

    # A string representation of a share.
    #
    # Example
    #
    #   point = SecretSharing::Point.new 1, 2
    #   SecretSharing::Share.new(point).to_s
    #   # => "1-2"
    #
    def to_s
      "#{point.x}-#{point.y.to_s(16)}"
    end

    # Creates a share object from its string representation.
    #
    # Example
    #
    #   SecretSharing::Share.from_string "1-2"
    #   # => #<SecretSharing::Share:0x0000000 @point=...>
    #
    # @param share_string [String]
    # @return [SecretSharing::Share] parsed share
    def self.from_string(share_string)
      x_string, y_string = share_string.split '-'
      point = Point.new x_string.to_i, y_string.to_i(16)
      Share.new(point)
    end
  end
end
