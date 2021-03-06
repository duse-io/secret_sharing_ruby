require "securerandom"

RSpec.describe SecretSharing do
  it "should encrypt and decrypt correctly" do
    50.times do
      secret = SecureRandom.base64(130)
      num_of_shares = 2 + SecureRandom.random_number(100)
      shares = SecretSharing.split(secret, 2, num_of_shares)
      expect(SecretSharing.combine(shares[0..1])).to eq(secret)
    end
  end

  context "threshold 2 out of 4 shares" do
    subject(:shares) { SecretSharing.split("secret", 2, 4) }

    it "generates point objects" do
      shares.each { |share| expect(share).to be_a SecretSharing::Point }
    end

    it "generates 4 shares" do
      expect(shares.length).to eq 4
    end

    it "cannot reconstruct with only one share" do
      expect(SecretSharing.combine(shares[0, 1])).not_to eq "secret"
    end

    it "can reconstruct the secret with any combination of 2 shares" do
      shares.permutation(2).each do |share_combination|
        expect(SecretSharing.combine(share_combination)).to eq "secret"
      end
    end

    it "can reconstruct the secret with any combination of 3 shares" do
      shares.permutation(3).each do |share_combination|
        expect(SecretSharing.combine(share_combination)).to eq "secret"
      end
    end

    it "can reconstruct the secret with all shares" do
      expect(SecretSharing.combine(shares)).to eq "secret"
    end
  end
end
