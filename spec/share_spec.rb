describe SecretSharing::Share do
  it 'correctly parses a string representation of a share' do
    expect(SecretSharing::Share.parse('$$ASCII-1-2')).to eq(['$$ASCII', '1-2'])
  end

  it 'correctly parses a share when charset contains a "-"' do
    expect(SecretSharing::Share.parse('tes--1-2')).to eq(['tes-', '1-2'])
  end
end
