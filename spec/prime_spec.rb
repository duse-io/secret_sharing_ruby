RSpec.describe SecretSharing::Prime do
  describe "#get_large_enough_prime" do
    it "calc the correct prime" do
      expect(SecretSharing::Prime.large_enough_prime(4)).to eq(7)
    end
  end
end
