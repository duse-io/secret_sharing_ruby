require 'spec_helper'
require 'securerandom'

describe SecretSharing do
  it 'should encrypt and decrypt correctly' do
    5.times do |i|
      puts "\nRun ##{i}"

      secret = SecureRandom.base64(10)
      puts "Secret: #{secret}"
      shares = SecretSharing.split_secret(secret, 2, 3)
      puts '--------------'
      puts 'done splitting'
      puts '--------------'
      puts "Shares: #{shares}"
      expect(SecretSharing.recover_secret(shares[0..1])).to eq(secret)
    end
  end
end
