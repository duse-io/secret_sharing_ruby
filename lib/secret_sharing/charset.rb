module SecretSharing
  class Charset
    def initialize(charset)
      @charset = charset.unshift("\u0000")
    end

    def self.from_string(charset_string)
      Charset.new charset_string.chars.shuffle.uniq
    end

    def i_to_s(x)
      unless x.is_a?(Integer) && x >= 0
        fail ArgumentError, 'x must be a non-negative integer'
      end

      output = ''
      while x > 0
        x, codepoint = x.divmod(length)
        output.prepend(codepoint_to_char(codepoint))
      end
      output
    end

    def s_to_i(str)
      str.chars.reduce(0) do |output, char|
        output * length + char_to_codepoint(char)
      end
    end

    def codepoint_to_char(codepoint)
      char = @charset[codepoint]
      return char unless char.nil?
      fail ArgumentError, "Codepoint #{codepoint} does not exist in charset"
    end

    def char_to_codepoint(c)
      codepoint = @charset.rindex c
      return codepoint unless codepoint.nil?
      fail ArgumentError, "Character \"#{c}\" not part of the supported charset"
    end

    def length
      @charset.length
    end

    def to_s
      @charset[1...length].join
    end
  end

  class HexCharset
    def i_to_s(x)
      x.to_s(16)
    end

    def s_to_i(str)
      str.to_i(16)
    end
  end
end
