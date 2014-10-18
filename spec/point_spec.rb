describe SecretSharing::Point do
  context '#new' do
    it 'should error if any argument for initialization are not integers' do
      s = 'string' # string
      i = 1        # int
      expect { SecretSharing::Point.new(s, s) }.to raise_error(ArgumentError)
      expect { SecretSharing::Point.new(i, s) }.to raise_error(ArgumentError)
      expect { SecretSharing::Point.new(s, i) }.to raise_error(ArgumentError)
    end
  end

  context '.inspect' do
    it 'should follow the ruby convention when inspecting' do
      point = SecretSharing::Point.new(1, 2)
      expect(point.inspect).to eq('#<Point: @x=1 @y=2>')
    end
  end
end
