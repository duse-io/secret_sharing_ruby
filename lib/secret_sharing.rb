require "secret_sharing/version"
require "secret_sharing/point"
require "secret_sharing/polynomial"
require "secret_sharing/prime"
require "secret_sharing/encoder"

module SecretSharing
  def split_secret(secret_string, share_threshold, num_shares)
    secret_int = PrintableEncoder.s_to_i(secret_string)
    points = Point.points_from_secret(secret_int, share_threshold, num_shares)
    shares = []
    points.each do |point|
      shares << point.to_share
    end
    shares
  end

  def recover_secret(shares)
    points = []
    shares.each do |share|
      points << Point.from_share(share)
    end
    secret_int = Point.to_secret_int(points)
    secret_string = PrintableEncoder.i_to_s(secret_int)
  end

  module_function :split_secret, :recover_secret
end
