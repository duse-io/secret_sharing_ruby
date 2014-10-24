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
    #   # => #<SecretSharing::ASCIICharset @charset=[...]>
    #
    # Or with a custom charset
    #
    #   SecretSharing::Charset.by_string 'testä'
    #   # => #<SecretSharing::DynamicCharset @charset=["s", "e", "ä", "t"]>
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
    #   SecretSharing::Charset.by_charset_string ''
    #   # => #<SecretSharing::ASCIICharset @charset=[...]>
    #
    # Or in case of a custom charset
    #
    #   SecretSharing::Charset.by_charset_string 'tesä'
    #   # => #<SecretSharing::DynamicCharset @charset=["t", "e", "s", "ä"]>
    #
    # @param charset_string [String] The string to evaluate the charset for.
    # @return A charset that has at least the methods #s_to_i and #i_to_s.
    def by_charset_string(charset_string)
      return ASCIICharset.new if charset_string.empty?
      DynamicCharset.new(charset_string.chars)
    end

    module_function :by_string,
                    :by_charset_string
  end

  module Charset
    # This objects of this class can represent a custom charset whenever the
    # predefined charsets do not fit a situation.
    class DynamicCharset
      # A new instance of DynamicCharset. The constructor should only be used
      # when you know what you are doing. Usually you only want to use this
      # constructor when you recreate a charset and the order of the charset is
      # important. The "null-byte" character is prepended to be the first
      # character in the charset to avoid loosing the first character of the
      # charset when it is also the first character in a string to convert.
      #
      # Example
      #
      #   SecretSharing::Charset::DynamicCharset.new ['a', 'b', 'c']
      #   # => #<SecretSharing::Charset::DynamicCharset @charset=[...]>
      #
      # @param charset [Array] array of characters to use for the charset.
      def initialize(charset)
        @charset = charset.unshift("\u0000")
      end

      # Create a charset based on a string to encode.
      #
      # Example
      #
      #   SecretSharing::Charset::DynamicCharset.from_string 'test'
      #   # => #<SecretSharing::Charset::DynamicCharset @charset=['e','t','s']>
      #
      # @param string [String] a string to encode with the charset to generate
      # @return [DynamicCharset] shuffled charset to encode strings to ints
      def self.from_string(string)
        DynamicCharset.new string.chars.shuffle.uniq
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
          output * length + char_to_codepoint(char)
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
        char = @charset[codepoint]
        return char unless char.nil?
        fail ArgumentError, "Codepoint #{codepoint} does not exist in charset"
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
        codepoint = @charset.rindex c
        return codepoint unless codepoint.nil?
        fail ArgumentError, "Character \"#{c}\" not part of the supported charset"
      end

      # Total length of the charset
      #
      # Example
      #
      #   charset = SecretSharing::Charset.by_charset_string 'abc'
      #   charset.length
      #   # => 4
      def length
        @charset.length
      end

      # Adds a string representation of the charset to the string, which can
      # later be used to recreate the charset.
      #
      #   Example
      #
      #     charset = SecretSharing::Charset.by_charset_string 'abc'
      #     charset.add_to_point('1-2')
      #     # => "abc-1-2"
      #
      # @param point_string [String] string to prepend to
      # @return [String] string representation of charset-point_string
      def add_to_point(point_string)
        "#{@charset[1...length].join}-#{point_string}"
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
        (Set.new(string.chars.uniq) - Set.new(@charset)).empty?
      end
    end

    # Charset that can represent any string that only consists of ASCII
    # characters.
    class ASCIICharset < DynamicCharset
      # An instance of an ASCIICharset is just a DynamicCharset with the ASCII
      # characters.
      def initialize
        super((1..127).to_a.map(&:chr))
      end

      # Adds a string representation of the charset to the string (empty string
      # in case of ASCII, since it is the default charset), which can later be
      # used to recreate the charset.
      #
      # Example
      #
      #   charset = SecretSharing::Charset.by_charset_string 'abc'
      #   charset.add_to_point('1-2')
      #   # => "abc-1-2"
      #
      # @param point_string [String] string to prepend to
      # @return [String] string representation of charset-point_string
      def add_to_point(point_string)
        point_string
      end
    end
  end
end
