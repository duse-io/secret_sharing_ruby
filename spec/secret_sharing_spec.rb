require 'securerandom'

describe SecretSharing do
  it 'should encrypt and decrypt correctly' do
    50.times do
      secret = SecureRandom.base64(130)
      num_of_shares = 2 + SecureRandom.random_number(100)
      shares = SecretSharing.split_secret(secret, 2, num_of_shares)
      expect(SecretSharing.recover_secret(shares[0..1])).to eq(secret)
    end
  end

  it 'should work with non ascii characters as well' do
    secret = 'κόσμε'
    num_of_shares = 2 + SecureRandom.random_number(100)
    shares = SecretSharing.split_secret(secret, 2, num_of_shares)
    expect(SecretSharing.recover_secret(shares[0..1])).to eq(secret)
  end
end
