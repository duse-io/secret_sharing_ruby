require 'securerandom'

describe SecretSharing::Charset do
  context 'encode and decode' do
    it 'should be able to decode randomly generated encoded strings' do
      50.times do
        str = SecureRandom.base64(100)
        charset = SecretSharing::Charset::ASCIICharset.new
        encoded = charset.s_to_i(str)
        decoded = charset.i_to_s(encoded)
        expect(decoded).to eq(str)
      end
    end

    it 'should throw errors when characters that are not in charset' do
      charset = SecretSharing::Charset::ASCIICharset.new
      expect { charset.codepoint_to_char(130) }.to raise_error(ArgumentError)
      expect { charset.char_to_codepoint('ä') }.to raise_error(ArgumentError)
    end

    it 'should throw an error when trying to convert negative numbers' do
      charset = SecretSharing::Charset::ASCIICharset.new
      expect { charset.i_to_s(-1) }.to raise_error(ArgumentError)
    end

    it 'should throw an error when trying to convert something non-integer' do
      charset = SecretSharing::Charset::ASCIICharset.new
      expect { charset.i_to_s('error') }.to raise_error(ArgumentError)
    end
  end
end
