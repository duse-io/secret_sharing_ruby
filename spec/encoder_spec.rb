require 'spec_helper'
require 'securerandom'

describe SecretSharing::PrintableEncoder do
  context '#encode and #decode' do
    it 'should be able to decode randomly generated encoded strings' do
      50.times do |i|
        str = SecureRandom.base64(100)
        encoded = SecretSharing::PrintableEncoder.s_to_i(str)
        decoded = SecretSharing::PrintableEncoder.i_to_s(encoded)
        expect(decoded).to eq(str)
      end
    end
  end
end
