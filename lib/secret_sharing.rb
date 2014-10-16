require "secret_sharing/version"
require "secret_sharing/point"
require "secret_sharing/polynomial"
require "secret_sharing/prime"
require "secret_sharing/encoder"

module SecretSharing
  def split_secret(secret_string, share_threshold, num_shares)
    encoder = Encoder.new(secret_string)
    secret_int = encoder.s_to_i(secret_string)
    points = Point.points_from_secret(secret_int, share_threshold, num_shares)
    shares = []
    points.each do |point|
      shares << encoder.to_s + '-' + point.to_share
    end
    shares
  end

  def recover_secret(shares)
    points = []
    shares.each do |share|
      points << Point.from_share(share)
    end
    secret_int = Point.to_secret_int(points)

    number_of_dashes = 0
    charset = ""
    shares.first.split(//).reverse.each do |char|
      if number_of_dashes >= 2
        charset.prepend(char)
      end
      number_of_dashes += 1 if char == '-'
    end
    secret_string = Encoder.new(charset).i_to_s(secret_int)
  end

  module_function :split_secret, :recover_secret
end
