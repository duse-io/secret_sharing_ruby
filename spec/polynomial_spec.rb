describe SecretSharing::Charset do
  it 'should error when trying to generate a polynomial with negative degree' do
    random_generator = lambda { SecretSharing::Polynomial.random -1, 1, 12 }
    expect(&random_generator).to raise_error(ArgumentError)
  end

  it 'should error when the secret is to long' do
    secret = 2**10000
    block = lambda do
      SecretSharing::Polynomial.points_from_secret(secret, 2, 3)
    end
    expect(&block).to raise_error(ArgumentError)
  end

  it 'should error when the point threshold is too small' do
    block = lambda do
      SecretSharing::Polynomial.points_from_secret(123, 1, 3)
    end
    expect(&block).to raise_error(ArgumentError)
  end

  it 'should error when the point threshold is larger than total points' do
    block = lambda do
      SecretSharing::Polynomial.points_from_secret(123, 3, 2)
    end
    expect(&block).to raise_error(ArgumentError)
  end
end
