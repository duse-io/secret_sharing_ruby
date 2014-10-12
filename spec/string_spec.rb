require 'spec_helper'

describe String do
  context '#int_to_charset' do
    it 'should return "1n" for 123' do
      expect(String.int_to_charset(123, SecretSharing::Charset.printable)).to eq("1n")
    end
  end

  context '#charset_to_int' do
    it 'should return 3707 for "B7"' do
      expect("B7".charset_to_int(SecretSharing::Charset.printable)).to eq(3707)
    end

    it 'should return 12242727141229941724272814941110292914273494282910252114 for "correct horse battery staple"' do
      expect("correct horse battery staple".charset_to_int(SecretSharing::Charset.printable)).to eq(12242727141229941724272814941110292914273494282910252114)
    end
  end

  context '#in_charset?' do
    it 'should return an empty set' do
      expect("test123".in_charset?(SecretSharing::Charset.printable)).to be(true)
    end
  end
end
