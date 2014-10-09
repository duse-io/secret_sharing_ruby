require 'spec_helper'

describe String do
  context '#int_to_charset' do
    it 'should return "B7" for 123' do
      expect(String.int_to_charset(123, "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/")).to eq("B7")
    end
  end

  context '#charset_to_int' do
    it 'should return 123 for "B7"' do
      expect("B7".charset_to_int("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/")).to eq(123)
    end
  end

  context '#diff' do
    it 'should return an empty set' do
      expect("test123".diff("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/")).to eq(Set.new)
    end
  end
end
