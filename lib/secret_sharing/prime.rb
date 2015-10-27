module SecretSharing
  # This module is used to generate/calculate/retrieve primes.
  module Prime
    class CannotFindLargeEnoughPrime < StandardError; end

    extend self

    # Retrieves the next largest prime for the largest number in batch
    #
    # Example
    #
    #   Prime.large_enough_prime 4
    #   # => 7
    #
    # @param input [Integer] the integer to find the next largest prime for
    # @return [Integer] the next largest prime
    # @raise [CannotFindLargeEnoughPrime] raised when input is too large and
    #   no large enough prime can be found
    def large_enough_prime(input)
      standard_primes.each do |prime|
        return prime if prime > input
      end
      fail CannotFindLargeEnoughPrime, "Input too large"
    end

    private

    # Merges the mersenne primes with the smallst 257, 321, and 385 bit primes
    def standard_primes
      mersenne_primes + [
        # smallest 257, 321 and 385 bit primes
        2**256 + 297, 2**320 + 27, 2**384 + 231
      ].sort
    end

    # Calculates the first 15 mersenne primes
    def mersenne_primes
      mersenne_prime_exponents = [
        2, 3, 5, 7, 13, 17, 19, 31, 61, 89, 107, 127, 521, 607, 1279
      ]
      mersenne_prime_exponents.map do |exp|
        (2**exp) - 1
      end
    end
  end
end
