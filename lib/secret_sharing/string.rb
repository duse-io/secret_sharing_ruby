class String
  def self.int_to_charset(x, charset)
    if not (x.is_a?(Integer) && x >= 0)
      raise ArgumentError, 'x must be a non-negative integer'
    end
    if x == 0
      return charset[0]
    end
    output = ""
    while x > 0
      x, digit = x.divmod(charset.length)
      output += charset[digit]
    end
    output.reverse
  end

  def charset_to_int(charset)
    if not self.in_charset?(charset)
      raise ArgumentError, 'contains chars that are not in charset'
    end
    output = 0
    self.each_char do |c|
      output = output * charset.length + charset.rindex(c)
    end
    output
  end

  def in_charset?(charset)
    !!(Set.new(self.split(//).uniq) - charset)
  end
end
