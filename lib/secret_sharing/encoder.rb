module SecretSharing
  module Encoder
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
      str.each_codepoint do |codepoint|
        output = output * charset_length + codepoint
      end
      output
    end

    def codepoint_to_char(codepoint)
      [codepoint.to_s(16).hex].pack("U")
    end

    def char_to_codepoint(char)
      char.codepoints[0]
    end

    def charset_length
      1112064
    end

    module_function :i_to_s,
                    :s_to_i,
                    :codepoint_to_char,
                    :char_to_codepoint,
                    :charset_length
  end
end
