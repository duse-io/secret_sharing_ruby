require 'set'

module SecretSharing
  # Charset can represent any charset which does not have the null byte
  class Charset
    # @return [Array] internal representation of the charset
    attr_reader :charset

    # The "null-byte" character is prepended to be the first character in the
    # charset to avoid loosing the first character of the charset when it is
    # also the first character in a string to convert.
    #
    # Example
    #
    #   SecretSharing::Charset::DynamicCharset.new ['a', 'b', 'c'] # =>
    #   #<SecretSharing::Charset::DynamicCharset @charset=[...]>
    #
    # @param charset [Array] array of characters to use for the charset.
    def initialize(charset)
      @charset = ["\u0000"] + charset
      @charset.freeze
    end

    # Calculate a string from an integer.
    #
    # Example
    #
    #   charset = SecretSharing::Charset.by_charset_string 'abc'
    #   charset.i_to_s 6
    #   # => "ab"
    #
    # @param x [Integer] integer to convert to string
    # @return [String] converted string
    def i_to_s(x)
      if !x.is_a?(Integer) || x < 0
        fail ArgumentError, 'x must be a non-negative integer'
      end

      output = ''
      while x > 0
        x, codepoint = x.divmod(charset.length)
        output.prepend(codepoint_to_char(codepoint))
      end
      output
    end

    # Calculate an integer from a string.
    #
    # Example
    #
    #   charset = SecretSharing::Charset.by_charset_string 'abc'
    #   charset.s_to_i "ab"
    #   # => 6
    #
    # @param string [Integer] integer to convert to string
    # @return [String] converted string
    def s_to_i(string)
      string.chars.reduce(0) do |output, char|
        output * charset.length + char_to_codepoint(char)
      end
    end

    # Convert an integer into its string representation according to the
    # charset. (only one character)
    #
    # Example
    #
    #   charset = SecretSharing::Charset.by_charset_string 'abc'
    #   charset.codepoint_to_char 1
    #   # => "a"
    #
    # @param codepoint [Integer] Codepoint to retrieve the character for
    # @return [String] Retrieved character
    def codepoint_to_char(codepoint)
      if charset.at(codepoint).nil?
        fail ArgumentError, "Codepoint #{codepoint} does not exist in charset"
      end
      charset.at(codepoint)
    end

    # Convert a single character into its integer representation according to
    # the charset.
    #
    # Example
    #
    #   charset = SecretSharing::Charset.by_charset_string 'abc'
    #   charset.char_to_codepoint 'a'
    #   # => 1
    #
    # @param c [String] Character to retrieve its codepoint in the charset
    # @return [Integer] Codepoint within the charset
    def char_to_codepoint(c)
      codepoint = charset.index c
      if codepoint.nil?
        error_msg = "Character \"#{c}\" not part of the supported charset"
        fail ArgumentError, error_msg
      end
      codepoint
    end

    # Check if the provided string can be represented by the charset.
    #
    # Example
    #
    #   charset = SecretSharing::Charset.by_charset_string 'abc'
    #   charset.subset? 'd'
    #   # => false
    #   charset.subset? 'a'
    #   # => true
    #
    # @param string [String] Character to retrieve the for codepoint
    # @return [TrueClass|FalseClass]
    def subset?(string)
      (string.chars - charset).empty?
    end

    # Charset that can represent any string that only consists of ASCII
    # characters.
    ASCIICharset = new((1..127).to_a.map(&:chr))
  end
end

