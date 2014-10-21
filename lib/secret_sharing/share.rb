module SecretSharing
  # A share is an object that encapsulates the properties of a share created by
  # Shamir's Secret Sharing algorithm.
  class Share
    attr_reader :charset, :point

    # Create a share object
    #
    # Example
    #
    #   charset = SecretSharing::ASCIICharset.new
    #   point = SecretSharing::Point.new 1, 2
    #   SecretSharing::Share.new charset, point
    #   # => #<SecretSharing::Share:0x0000000 @charset=..., @point=...>
    #
    def initialize(charset, point)
      unless charset.is_a?(SecretSharing::DynamicCharset)
        fail ArgumentError, 'Charset must be a SecretSharing::DynamicCharset'
      end
      unless point.is_a?(SecretSharing::Point)
        fail ArgumentError, 'Point must be SecretSharing::Point'
      end

      @charset = charset
      @point = point
    end

    # A string representation of a share.
    #
    # Example
    #
    #   charset = SecretSharing::ASCIICharset.new
    #   point = SecretSharing::Point.new 1, 2
    #   SecretSharing::Share.new(charset, point).to_s
    #   # => "$$ASCII-1-2"
    #
    def to_s
      charset.to_s + '-' + @point.x.to_s + '-' + @point.y.to_s(16)
    end

    # Creates a share object from its string representation.
    #
    # Example
    #
    #   SecretSharing::Share.from_string "$$ASCII-1-2"
    #   # => #<SecretSharing::Share:0x0000000 @charset=..., @point=...>
    #
    def self.from_string(share_string)
      charset_string, x_share, y_share = parse share_string
      charset = Charset.by_charset_string charset_string
      point = Point.new(x_share.to_i, y_share.to_i(16))
      Share.new(charset, point)
    end

    # Parses the string representation of a share into charset, the x and the y
    # coordinate out of a string representation of a share. Since the charset
    # part can have a "-" in it it must be parsed backwards and not just
    # splitted by "-".
    #
    # Example
    #
    #   SecretSharing::Share.parse '$$ASCII-1-2'
    #   # => ['$$ASCII', '1', '2']
    #
    # @param share_string [String] a string representation of a share
    # @return an array in form of [charset_string, x_string, y_string]
    #
    def self.parse(share_string)
      charset_string, x_share, y_share = '', '', ''
      number_of_dashes = 0
      share_string.chars.reverse.each do |char|
        y_share.prepend(char) if number_of_dashes == 0 && char != '-'
        x_share.prepend(char) if number_of_dashes == 1 && char != '-'
        charset_string.prepend(char) if number_of_dashes >= 2
        number_of_dashes += 1 if char == '-'
      end
      [charset_string, x_share, y_share]
    end
  end
end
