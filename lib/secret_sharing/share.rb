module SecretSharing
  class Share
    attr_reader :charset, :point

    def initialize(charset, point)
      @charset = charset
      @point = point
    end

    def to_s
      charset.to_s + '-' + @point.x.to_s + '-' + HexCharset.new.i_to_s(@point.y)
    end

    def self.from_string(share_string)
      charset_string, x_share, y_share = parse share_string
      charset = Charset.new charset_string.chars
      point = Point.new(x_share.to_i, HexCharset.new.s_to_i(y_share))
      Share.new(charset, point)
    end

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
