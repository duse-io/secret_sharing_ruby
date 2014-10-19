describe SecretSharing::Prime do
  context '#get_large_enough_prime' do
    it 'should calc the correct prime' do
      expect(SecretSharing::Prime.large_enough_prime([1, 2, 3, 4])).to eq(7)
    end
  end
end
