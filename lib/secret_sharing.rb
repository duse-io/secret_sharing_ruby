require "secret_sharing/version"
require "secret_sharing/point"
require "secret_sharing/polynomial"
require "secret_sharing/prime"
require "secret_sharing/charset"
require "secret_sharing/encoder"
require "secret_sharing/decoder"

module SecretSharing
  def split_secret(secret_string, share_threshold, num_shares)
    Encoder.encode(secret_string, share_threshold, num_shares)
  end

  def recover_secret(shares)
    Decoder.decode(shares)
  end

  module_function :split_secret, :recover_secret
end
