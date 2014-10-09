module SecretSharing
  module Prime
    def calculate_mersenne_primes
      mersenne_prime_exponents = [
        2, 3, 5, 7, 13, 17, 19, 31, 61, 89, 107, 127, 521, 607, 1279
      ]
      primes = []
      mersenne_prime_exponents.each do |exp|
        prime = 1
        prime *= 2**exp
        prime -= 1
        primes << prime
      end
      primes
    end

    def get_large_enough_prime(batch)
      smallest_257bit_prime = (2**256 + 297)
      smallest_321bit_prime = (2**320 + 27)
      smallest_385bit_prime = (2**384 + 231)
      standard_primes = calculate_mersenne_primes() + [
        smallest_257bit_prime, smallest_321bit_prime, smallest_385bit_prime
      ]
      standard_primes.sort

      standard_primes.each do |prime|
        greater_than_prime = Array.new(batch).select {|i| i if i > prime}
        if greater_than_prime.length == 0
          return prime
        end
      end
      return nil
    end

    module_function :calculate_mersenne_primes,
                    :get_large_enough_prime
  end
end
