require "secret_sharing/version"
require "secret_sharing/point"
require "secret_sharing/polynomial"
require "secret_sharing/prime"
require "secret_sharing/string"
require "secret_sharing/charset"

module SecretSharing
  def split_secret(secret_string, share_threshold, num_shares)
    secret_int = secret_string.charset_to_int Charset::PRINTABLE
    points = Point.points_from_secret(secret_int, share_threshold, num_shares)
    shares = []
    points.each do |point|
      shares << point.to_share(Charset::HEX)
    end
    shares
  end

  def recover_secret(shares)
    points = []
    shares.each do |share|
      points << share_string_to_point(share, Charset::HEX)
    end
    secret_int = points_to_secret_int(points)
    secret_string = int_to_charset secret_int, Charset::PRINTABLE
  end

  module_function :split_secret, :recover_secret
end
