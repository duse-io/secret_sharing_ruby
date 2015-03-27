RSpec.describe SecretSharing::Point do
  describe '#initialize' do
    it 'sets the coordinates correctly' do
      x = 1
      y = 2
      point = SecretSharing::Point.new(1, 2)
      expect(point.x).to be 1
      expect(point.y).to be 2
    end
  end

  describe '.transpose' do
    it 'returns an array consisting of two further arrays' do
      result = SecretSharing::Point.transpose []
      expect(result).to be_an Array
      expect(result.length).to be 2
      expect(result.first).to be_an Array
      expect(result.last).to be_an Array
    end

    it 'puts all x values in the first and all y values in the second array' do
      result = SecretSharing::Point.transpose([
        SecretSharing::Point.new(1,2),
        SecretSharing::Point.new(3,4),
        SecretSharing::Point.new(5,6)
      ])
      expect(result).to eq([
        [1,3,5],
        [2,4,6]
      ])
    end
  end
end

