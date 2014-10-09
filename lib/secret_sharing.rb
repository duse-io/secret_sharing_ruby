require "secret_sharing/version"
require "secret_sharing/point"
require "secret_sharing/polynomial"
require "secret_sharing/prime"
require "secret_sharing/string"

module SecretSharing
  def split_secret(secret_string, share_threshold, num_shares)
    secret_int = secret_string.charset_to_int('0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!"#$%&\'()*+,-./:;<=>?@[\\]^_`{|}~ \t\n\r\x0b\x0c')
    points = Point.points_from_secret(secret_int, share_threshold, num_shares)
    shares = []
    points.each do |point|
      shares << point.to_share('0123456789abcdef')
    end
    shares
  end

  def recover_secret(shares)
    points = []
    shares.each do |share|
      points << share_string_to_point(share, "0123456789abcdef")
    end
    secret_int = points_to_secret_int(points)
    secret_string = int_to_charset(secret_int, '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!"#$%&\'()*+,-./:;<=>?@[\\]^_`{|}~ \t\n\r\x0b\x0c')
  end

  module_function :split_secret, :recover_secret
end
