require 'securerandom'

describe SecretSharing::Charset do
  context 'encode and decode' do
    it 'should be able to decode randomly generated encoded strings' do
      50.times do
        str = SecureRandom.base64(100)
        encoded = SecretSharing::Charset.new(str.chars).s_to_i(str)
        decoded = SecretSharing::Charset.new(str.chars).i_to_s(encoded)
        expect(decoded).to eq(str)
      end
    end

    it 'should throw errors when characters that are not in charset' do
      encoder = SecretSharing::Charset.new('test'.chars)
      expect { encoder.codepoint_to_char(5) }.to raise_error(ArgumentError)
      expect { encoder.char_to_codepoint('r') }.to raise_error(ArgumentError)
    end

    it 'should throw an error when trying to convert negative numbers' do
      encoder = SecretSharing::Charset.new('test'.chars)
      expect { encoder.i_to_s(-1) }.to raise_error(ArgumentError)
    end

    it 'should throw an error when trying to convert something non-integer' do
      encoder = SecretSharing::Charset.new('test'.chars)
      expect { encoder.i_to_s('error') }.to raise_error(ArgumentError)
    end
  end
end

describe SecretSharing::HexCharset do
  context 'encode and decode' do
    it 'should be able to decode randomly generated encoded strings' do
      50.times do
        str = SecureRandom.hex(100)
        while true
          break unless str[0] == '0'
          str = SecureRandom.hex(100)
        end
        encoded = SecretSharing::HexCharset.new.s_to_i(str)
        decoded = SecretSharing::HexCharset.new.i_to_s(encoded)
        expect(decoded).to eq(str)
      end
    end
  end
end
