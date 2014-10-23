require 'securerandom'

describe SecretSharing::Charset do
  context 'encode and decode' do
    it 'should be able to decode randomly generated encoded strings' do
      50.times do
        str = SecureRandom.base64(100)
        charset = SecretSharing::Charset.by_charset_string(str)
        encoded = charset.s_to_i(str)
        decoded = charset.i_to_s(encoded)
        expect(decoded).to eq(str)
      end
    end

    it 'should throw errors when characters that are not in charset' do
      encoder = SecretSharing::Charset.by_charset_string('test')
      expect { encoder.codepoint_to_char(5) }.to raise_error(ArgumentError)
      expect { encoder.char_to_codepoint('r') }.to raise_error(ArgumentError)
    end

    it 'should throw an error when trying to convert negative numbers' do
      encoder = SecretSharing::Charset.by_charset_string('test')
      expect { encoder.i_to_s(-1) }.to raise_error(ArgumentError)
    end

    it 'should throw an error when trying to convert something non-integer' do
      encoder = SecretSharing::Charset.by_charset_string('test')
      expect { encoder.i_to_s('error') }.to raise_error(ArgumentError)
    end

    it 'should return the correct charset for ""' do
      charset = SecretSharing::Charset.by_charset_string('')
      expect(charset).to be_a SecretSharing::Charset::ASCIICharset
    end
  end
end
