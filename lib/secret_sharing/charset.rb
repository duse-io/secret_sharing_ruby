module SecretSharing
  class Charset
    def initialize(charset_string)
      @charset = charset_string.split(//)
    end

    def [](index)
      @charset[index]
    end

    def rindex(char)
      @charset.rindex char
    end

    def length
      @charset.length
    end

    def include?(char)
      @charset.include? char
    end

    def subset?(string)
      !!(Set.new(string.split(//).uniq) - Set.new(@charset))
    end

    def self.printable
      Charset.new "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!\"\#$%&'()*+,-./:;<=>?@[\\]^_`{|}~ \t\n\r\v\f"
    end

    def self.hex
      Charset.new "0123456789abcdef"
    end
  end
end
