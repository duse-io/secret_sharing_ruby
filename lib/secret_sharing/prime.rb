module SecretSharing
  module Prime
    def mersenne_primes
      mersenne_prime_exponents = [
        2, 3, 5, 7, 13, 17, 19, 31, 61, 89, 107, 127, 521, 607, 1279
      ]
      mersenne_prime_exponents.map do |exp|
        prime = 1
        prime *= 2**exp
        prime -= 1
        prime
      end
    end

    def large_enough_prime(batch)
      standard_primes = mersenne_primes + [
        # smallest 257, 321 and 385 bit primes
        2**256 + 297, 2**320 + 27, 2**384 + 231
      ].sort

      standard_primes.each do |prime|
        greater_than_prime = Array.new(batch).select { |i| i if i > prime }
        return prime if greater_than_prime.empty?
      end
      nil
    end

    module_function :mersenne_primes,
                    :large_enough_prime
  end
end
