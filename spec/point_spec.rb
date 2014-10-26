describe SecretSharing::Point do
  it 'should follow the ruby convention when inspecting' do
    point = SecretSharing::Point.new(1, 2)
    expect(point.inspect).to eq('#<Point: @x=1 @y=2>')
  end

  it 'should correctly stringify a point' do
    expect(SecretSharing::Point.new(1, 2).to_s).to eq('1-2')
  end

  it 'should correctly create a point from a correctly formatted string' do
    expect(SecretSharing::Point.new(1, 2).to_s).to eq('1-2')
  end

  it 'should be able to recreate a point from its string representation' do
    point = SecretSharing::Point.new(1, 2)
    string = point.to_s
    reconstructed_point = SecretSharing::Point.from_string string
    expect(reconstructed_point.x).to eq(point.x)
    expect(reconstructed_point.y).to eq(point.y)
  end
end
