describe SecretSharing::Point do
  it 'should follow the ruby convention when inspecting' do
    point = SecretSharing::Point.new(1, 2)
    expect(point.inspect).to eq('#<Point: @x=1 @y=2>')
  end
end
