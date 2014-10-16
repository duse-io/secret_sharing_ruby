require "secret_sharing/version"
require "secret_sharing/point"
require "secret_sharing/polynomial"
require "secret_sharing/prime"
require "secret_sharing/charset"
require "secret_sharing/encoder"
require "secret_sharing/decoder"
require "secret_sharing/share"

module SecretSharing
  def split_secret(secret_string, share_threshold, num_shares)
    charset = Charset.new(secret_string)
    secret_int = charset.s_to_i(secret_string)
    points = Encoder.points_from_secret(secret_int, share_threshold, num_shares)
    points.map do |point|
      Share.new(charset, point).to_s
    end
  end

  def recover_secret(raw_shares)
    shares = raw_shares.map do |raw_share|
      Share.from_string raw_share
    end
    points = shares.map do |share|
      share.point
    end
    secret_int = Decoder.points_to_secret_int(points)
    shares.first.charset.i_to_s(secret_int)
  end

  module_function :split_secret,
                  :recover_secret
end
