require 'securerandom'

describe SecretSharing do
  it 'should encrypt and decrypt correctly' do
    50.times do |i|
      secret = SecureRandom.base64(100)
      num_of_shares = 2 + SecureRandom.random_number(100)
      shares = SecretSharing.split_secret(secret, 2, 3)
      expect(SecretSharing.recover_secret(shares[0..1])).to eq(secret)
    end
  end
end
