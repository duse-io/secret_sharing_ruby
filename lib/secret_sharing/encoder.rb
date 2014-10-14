module SecretSharing
  class Encoder
    def self.i_to_s(x)
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

    def self.s_to_i(str)
      output = 0
      str.each_char do |char|
        output = output * charset_length + char_to_codepoint(char)
      end
      output
    end

    def self.codepoint_to_char(codepoint)
      charset.each_with_index do |c, index|
        return c if codepoint == index
      end
      raise ArgumentError, "Codepoint #{codepoint} does not exist in charset"
    end

    def self.char_to_codepoint(char)
      charset.each_with_index do |c, index|
        return index if char == c
      end
      raise ArgumentError, "Character \"#{char}\" not part of the supported charset"
    end

    def self.charset_length
      charset.length
    end

    def self.charset
      raise NotImplementedError
    end
  end

  class PrintableEncoder < Encoder
    def self.charset
      "\u00000123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!\"\#$%&'()*+,-./:;<=>?@[\\]^_`{|}~ \t\n\r\v\f".split(//)
    end
  end

  class HexEncoder < Encoder
    def self.charset
      "0123456789abcdef".split(//)
    end
  end
end
