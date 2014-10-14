require 'spec_helper'
require 'securerandom'

describe SecretSharing do
  it 'should encrypt and decrypt correctly' do
    50.times do |i|
      secret = SecureRandom.base64(10)
      shares = SecretSharing.split_secret(secret, 2, 3)
      expect(SecretSharing.recover_secret(shares[0..1])).to eq(secret)
    end
  end
end
