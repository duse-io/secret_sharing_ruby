require 'spec_helper'
require 'securerandom'

describe SecretSharing do
  it 'should encrypt and decrypt correctly' do
    5.times do |i|
      puts "\nRun ##{i}"

      secret = SecureRandom.base64(144)
      num_of_shares = 2 + SecureRandom.random_number(100)

      puts "Secret: #{secret}"
      puts "# of shares: #{num_of_shares}"

      shares = SecretSharing.split_secret(secret, 2, 3)
      expect(SecretSharing.recover_secret(shares[0..1])).to eq(secret)
    end
  end

  it '' do
    secret = "0QSkpBr9wWWUpYIWWkqi6MhpGfkodyYsSGT559U7zQuLS/j4fyHsdLdkpm45r68RLNYRywC1McrqxZy+rxiD/lbr"
    shares = SecretSharing.split_secret(secret, 2, 89)
    expect(SecretSharing.recover_secret(shares[0..1])).to eq(secret)
  end
end

