module SecretSharing
  class Encoder
    def initialize(charset)
      @charset = ("\u0000" + charset).split(//).uniq
    end

    def i_to_s(x)
      if not (x.is_a?(Integer) && x >= 0)
        raise ArgumentError, 'x must be a non-negative integer'
      end
      if x == 0
        return codepoint_to_char(0)
      end
      output = ""
      while x > 0
        x, codepoint = x.divmod(charset_length)
        output.prepend(codepoint_to_char(codepoint))
      end
      output
    end

    def s_to_i(str)
      output = 0
      str.each_char do |char|
        output = output * charset_length + char_to_codepoint(char)
      end
      output
    end

    def codepoint_to_char(codepoint)
      @charset.each_with_index do |c, index|
        return c if codepoint == index
      end
      raise ArgumentError, "Codepoint #{codepoint} does not exist in charset"
    end

    def char_to_codepoint(char)
      @charset.each_with_index do |c, index|
        return index if char == c
      end
      raise ArgumentError, "Character \"#{char}\" not part of the supported charset"
    end

    def charset_length
      @charset.length
    end

    def to_s
      @charset.join
    end
  end

  class HexEncoder < Encoder
    def initialize
      super "0123456789abcdef"
    end
  end
end
