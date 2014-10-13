module SecretSharing
  module Encoder
    UTF8_LENGTH = 1112064

    def i_to_s(x)
      if not (x.is_a?(Integer) && x >= 0)
        raise ArgumentError, 'x must be a non-negative integer'
      end
      if x == 0
        return [0.to_s(16).hex].pack("U")
      end
      output = ""
      while x > 0
        x, codepoint = x.divmod(UTF8_LENGTH)
        output.prepend([codepoint.to_s(16).hex].pack("U"))
      end
      output
    end

    def s_to_i(str)
      output = 0
      str.each_codepoint do |codepoint|
        output = output * UTF8_LENGTH + codepoint
      end
      output
    end

    module_function :i_to_s, :s_to_i
  end
end
