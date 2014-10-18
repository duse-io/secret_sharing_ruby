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
      smallest_257bit_prime = (2**256 + 297)
      smallest_321bit_prime = (2**320 + 27)
      smallest_385bit_prime = (2**384 + 231)
      standard_primes = mersenne_primes + [
        smallest_257bit_prime, smallest_321bit_prime, smallest_385bit_prime
      ]
      standard_primes.sort

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
