RSpec.describe SecretSharing::Polynomial do
  describe '#initialize' do
    it 'does not error when all coefficients are integers' do
      SecretSharing::Polynomial.new [1, 2, 3]
    end

    it 'makes the coefficients immutable' do
      polynomial = SecretSharing::Polynomial.new [1, 2, 3]
      expect(polynomial.coefficients).to eq [1, 2, 3]
      expect { polynomial.coefficients << 4 }.to raise_error(RuntimeError)
    end

    it 'raises an error when a coefficient is not an integer' do
      expect { SecretSharing::Polynomial.new(['']) }.to raise_error(
        ArgumentError,
        'One or more coefficents are not integers'
      )
    end
  end

  describe '#points' do
    context '5 points for f(x)=x^4 + 2' do
      subject(:polynomial) { SecretSharing::Polynomial.new([2, 0, 0, 0, 1]) }

      it 'generates 5 points' do
        expect(polynomial.points(5, 3).length).to eq 5
      end

      it 'generates points (1, 0), (2, 0) and (3, 2) for f(x)=x^4 + 2' do
        points = polynomial.points(5, 7)
        expect(points[0].x).to eq 1
        expect(points[0].y).to eq 3
        expect(points[1].x).to eq 2
        expect(points[1].y).to eq 4
        expect(points[2].x).to eq 3
        expect(points[2].y).to eq 6
        expect(points[3].x).to eq 4
        expect(points[3].y).to eq 6
        expect(points[4].x).to eq 5
        expect(points[4].y).to eq 4
      end
    end
  end

  describe '.random' do
    it 'errors when trying to generate a polynomial with negative degree' do
      random_generator = -> { SecretSharing::Polynomial.random(-1, 1, 12) }
      expect(&random_generator).to raise_error(
        ArgumentError,
        'Degree must be a non-negative number'
      )
    end

    it 'can create polynomials of degree 0' do
      polynomial = SecretSharing::Polynomial.random(0, 5, 10)
      expect(polynomial.coefficients).to eq [5]
    end

    it 'randomly generates coefficients' do
      allow(SecureRandom).to receive(:random_number).and_return(3, 5, 2)
      polynomial = SecretSharing::Polynomial.random(3, 5, 10)
      expect(polynomial.coefficients).to eq [5, 4, 6 ,3]
    end

    it 'ensures, that a coefficient is >= 1' do
      allow(SecureRandom).to receive(:random_number).and_return(0, 0, 0)
      polynomial = SecretSharing::Polynomial.random(3, 5, 10)
      expect(polynomial.coefficients).to eq [5, 1, 1 ,1]
    end

    it 'uses the intercept as the first coefficient' do
      polynomial = SecretSharing::Polynomial.random(3, 5, 10)
      expect(polynomial.coefficients.first).to eq 5
    end

    it 'creates a polynomial with degree as number of coefficients' do
      polynomial = SecretSharing::Polynomial.random(3, 3, 10)
      expect(polynomial.coefficients.length).to eq 4
    end
  end

  describe '.points_from_secret' do
    it 'generates points according to the num_points parameter' do
      points = SecretSharing::Polynomial.points_from_secret(10, 2, 4)
      expect(points.length).to eq 4
    end

    it 'requires threshold points to reconstruct' do
      points = SecretSharing::Polynomial.points_from_secret(234234, 2, 3)
      points = points[0, 2]
      secret = SecretSharing::Polynomial.modular_lagrange_interpolation(points)
      expect(secret).to eq 234234
    end

    it 'errors when the secret is to long' do
      secret = 2**10_000
      block = -> { SecretSharing::Polynomial.points_from_secret(secret, 2, 3) }
      expect(&block).to raise_error(
        ArgumentError,
        'Secret is too long'
      )
    end

    it 'errors when the point threshold is too small' do
      block = -> { SecretSharing::Polynomial.points_from_secret(123, 1, 3) }
      expect(&block).to raise_error(
        ArgumentError,
        'Threshold must be at least 2'
      )
    end

    it 'errors when the point threshold is larger than total points' do
      block = -> { SecretSharing::Polynomial.points_from_secret(123, 3, 2) }
      expect(&block).to raise_error(
        ArgumentError,
        'Threshold must be less than the total number of points'
      )
    end
  end
end
