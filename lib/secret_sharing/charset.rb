require 'set'

module SecretSharing
  # This module is used to create or retrieve a charset to use.
  module Charset
    # Decides which charset fits the provided string best and creates a custom
    # charset if no predefined charset fits the usecase.
    #
    # Example
    #
    #   SecretSharing::Charset.by_string 'test'
    #   # => #<SecretSharing::ASCIICharset:0x0000000 @charset=[...]>
    #
    # Or with a custom charset
    #
    #   SecretSharing::Charset.by_string 'testä'
    #   # => #<SecretSharing::DynamicCharset:0x0000000 @charset=["..."]>
    #
    # @param string [String] The string to evaluate the charset for.
    # @return A charset that has at least the methods #s_to_i and #i_to_s.
    def by_string(string)
      return ASCIICharset.new if ASCIICharset.new.subset?(string)
      DynamicCharset.from_string string
    end

    # Retrieves a charset based on its string representation.
    #
    # Example
    #
    #   SecretSharing::Charset.by_charset_string '$$ASCII'
    #   # => #<SecretSharing::ASCIICharset:0x0000000 @charset=[...]>
    #
    # Or in case of a custom charset
    #
    #   SecretSharing::Charset.by_charset_string 'tesä'
    #   # => #<SecretSharing::DynamicCharset:0x0000000 @charset=["..."]>
    #
    # @param string [String] The string to evaluate the charset for.
    # @return A charset that has at least the methods #s_to_i and #i_to_s.
    def by_charset_string(charset_string)
      charsets = {
        '$$ASCII' => ASCIICharset.new
      }
      result_charset = charsets[charset_string]
      result_charset || DynamicCharset.new(charset_string.chars)
    end

    module_function :by_string,
                    :by_charset_string
  end

  class DynamicCharset
    def initialize(charset)
      @charset = charset.unshift("\u0000")
    end

    def self.from_string(charset_string)
      DynamicCharset.new charset_string.chars.shuffle.uniq
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

    def subset?(string)
      (Set.new(string.chars.uniq) - Set.new(@charset)).empty?
    end
  end

  class ASCIICharset < DynamicCharset
    def initialize
      super((1..127).to_a.map(&:chr))
    end

    def to_s
      '$$ASCII'
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
