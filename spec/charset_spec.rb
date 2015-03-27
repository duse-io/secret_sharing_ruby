require 'securerandom'

describe SecretSharing::Charset::DynamicCharset do
  subject(:charset) { SecretSharing::Charset::DynamicCharset.new ['a', 'b', 'c'] }

  describe '#initialize' do
    it 'adds a non printable character in front of the charset' do
      expect(charset.charset).to eq ["\u0000", 'a', 'b', 'c']
    end

    it 'makes the internal representation of the charset immutable' do
      expect { charset.charset << 'x' }.to raise_error(RuntimeError)
    end
  end

  describe '#i_to_s' do
    it 'converts 0 to empty string' do
      expect(charset.i_to_s(0)).to eq ''
    end

    it 'converts 1 to "a"' do
      expect(charset.i_to_s(1)).to eq 'a'
    end

    it 'converts 6 to "ab"' do
      expect(charset.i_to_s(6)).to eq 'ab'
    end

    it 'throws an error when trying to convert negative numbers' do
      expect { charset.i_to_s(-1) }.to raise_error(
        ArgumentError,
        'x must be a non-negative integer'
      )
    end

    it 'throws an error when trying to convert something non-integer' do
      expect { charset.i_to_s('error') }.to raise_error(
        ArgumentError,
        'x must be a non-negative integer'
      )
    end
  end

  describe '#s_to_i' do
    it 'converts "a" to 1' do
      expect(charset.s_to_i('a')).to eq 1
    end

    it 'converts "ab" to 6' do
      expect(charset.s_to_i('ab')).to eq 6
    end
  end

  describe '#codepoint_to_char' do
    it 'returns "b" for 2' do
      expect(charset.codepoint_to_char(2)).to eq 'b'
    end

    it 'throws an error on an integer outside of the charset' do
      expect { charset.codepoint_to_char(4) }.to raise_error(
        ArgumentError,
        "Codepoint 4 does not exist in charset"
      )
    end
  end

  describe '#char_to_codepoint' do
    it 'returns 2 for "b"' do
      expect(charset.char_to_codepoint('b')).to eq 2
    end

    it 'throws an error on a character that is not in the charset' do
      expect { charset.char_to_codepoint('d') }.to raise_error(
        ArgumentError,
        "Character \"d\" not part of the supported charset"
      )
    end
  end

  describe '#subset?' do
    context 'the input is a subset' do
      it 'returns true' do
        expect(charset.subset?('ab')).to be true
      end
    end

    context 'the input is not a subset' do
      it 'returns false' do
        expect(charset.subset?('abcdef')).to be false
      end
    end

    context 'the input does not only contain unique characters' do
      it 'is still a subset' do
        expect(charset.subset?('aabc')).to be true
      end
    end
  end
end

#describe SecretSharing::Charset::ASCIICharset do
#  it 'supports all printable characters in ASCII' do
#    all_chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
#  end
#end

