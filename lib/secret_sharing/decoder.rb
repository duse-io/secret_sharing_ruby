module SecretSharing
  module Decoder
    def point_from_share(share)
      x_share = ""
      y_share = ""
      number_of_dashes = 0
      share.reverse.each_char do |char|
        number_of_dashes += 1 if char == '-'
        y_share.prepend(char) if number_of_dashes == 0
        x_share.prepend(char) if number_of_dashes == 1 && char != '-'
        break if number_of_dashes >= 2
      end
      Point.new(x_share.to_i, HexCharset.new.s_to_i(y_share))
    end

    def points_to_secret_int(points)
      x_values, y_values = Point.transpose(points)
      prime = SecretSharing::Prime.get_large_enough_prime(y_values)
      SecretSharing::Polynomial.modular_lagrange_interpolation(0, points, prime)
    end

    def decode(shares)
      points = []
      shares.each do |share|
        points << point_from_share(share)
      end
      secret_int = points_to_secret_int(points)

      number_of_dashes = 0
      charset = ""
      shares.first.split(//).reverse.each do |char|
        if number_of_dashes >= 2
          charset.prepend(char)
        end
        number_of_dashes += 1 if char == '-'
      end
      Charset.new(charset).i_to_s(secret_int)
    end

    module_function :point_from_share,
                    :points_to_secret_int,
                    :decode
  end
end
