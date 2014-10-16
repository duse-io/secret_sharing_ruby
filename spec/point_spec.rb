describe SecretSharing::Point do
  context '#new' do
    it 'should error if the arguments are not integers' do
      expect{SecretSharing::Point.new('1', '2')}.to raise_error(ArgumentError)
      expect{SecretSharing::Point.new(1, '2')}.to raise_error(ArgumentError)
      expect{SecretSharing::Point.new('1', 2)}.to raise_error(ArgumentError)
    end
  end

  context '.inspect' do
    it 'should follow the ruby convention when inspecting' do
      expect(SecretSharing::Point.new(1, 2).inspect).to eq("#<Point: @x=1 @y=2>")
    end
  end
end
