module SecretSharing
  class Charset < Set
    def [](key)
      self.to_a[key]
    end

    def rindex(key)
      self.to_a.each_with_index do |char, index|
        return index if char == key
      end
      return nil
    end

    def self.printable
      Charset.new "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!\"\#$%&'()*+,-./:;<=>?@[\\]^_`{|}~ \t\n\r\v\f".split(//)
    end

    def self.hex
      Charset.new "0123456789abcdef".split(//)
    end
  end
end
