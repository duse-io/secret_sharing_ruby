require "secret_sharing/version"
require "secret_sharing/point"
require "secret_sharing/polynomial"
require "secret_sharing/prime"
require "secret_sharing/charset"
require "secret_sharing/share"

module SecretSharing

  # Public: Split a secret using Shamir's Secret Sharing algorithm.
  #
  # secret_string   - The secret to split.
  # share_threshold - The number of shares that should be required to recover
  # the secret.
  # num_shares      - The total number of shares to generate.
  #
  # Example
  #
  #   SecretSharing.split_secret("my secret", 2, 3)
  #   # => ["my secrt-1-0ff4693f", "my secrt-2-2da39008", "my secrt-3-75bd29a"]
  #
  # Returns an array of shares that can be used to recover the secret
  def split_secret(secret_string, share_threshold, num_shares)
    charset = Charset.new(secret_string)
    secret_int = charset.s_to_i(secret_string)
    points = Polynomial.points_from_secret(secret_int, share_threshold, num_shares)
    points.map do |point|
      Share.new(charset, point).to_s
    end
  end

  # Public: Recover a secret with an array of string shares.
  #
  # raw_shares - The shares to recover the secret in form of an array of strings
  #
  # Example
  #
  #   SecretSharing.recover_secret(["my secrt-1-0ff4693f", "my secrt-2-2da39008"])
  #   # => "my secret"
  #
  # Returns the recovered secret in a string representation
  def recover_secret(raw_shares)
    shares = raw_shares.map do |raw_share|
      Share.from_string raw_share
    end
    points = shares.map do |share|
      share.point
    end
    secret_int = SecretSharing::Polynomial.modular_lagrange_interpolation(points)
    shares.first.charset.i_to_s(secret_int)
  end

  module_function :split_secret,
                  :recover_secret
end
