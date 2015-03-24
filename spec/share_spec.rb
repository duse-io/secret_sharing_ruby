describe SecretSharing::Share do
  it 'can create an instance from a string' do
    share = SecretSharing::Share.from_string('1-2')
    point = share.point
    expect(point.x).to be 1
    expect(point.y).to be 2
  end

  it 'correctly stringifies' do
    point = SecretSharing::Point.new(1, 2)
    expect(SecretSharing::Share.new(point).to_s).to eq('1-2')
  end
end
