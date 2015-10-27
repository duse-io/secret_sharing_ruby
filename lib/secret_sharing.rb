require "secret_sharing/version"
require "secret_sharing/point"
require "secret_sharing/polynomial"
require "secret_sharing/prime"
require "secret_sharing/charset"
require "secret_sharing/share"

# A ruby implementation of Shamir's Secret Sharing. This module is the only
# connection to be consumed by a user. Do not use any other class/module of
# this library unless you really know what you are doing.
module SecretSharing
  extend self

  # Split a secret using Shamir's Secret Sharing algorithm.
  #
  # Example
  #
  #   SecretSharing.split("secret", 2, 3)
  #   # => ["1-1e489c32507823aa", "2-1c9134c644739461", "3-1ad9cd5a386f0518"]
  #
  # @param secret_string [String] Secret to split.
  # @param share_threshold [Integer] Number of shares to recover the secret.
  # @param num_shares [Integer] Total number of shares to generate.
  #
  # @return [Array] Array of shares that can be used to recover the secret.
  def split(secret_string, share_threshold, num_shares)
    secret_int = Charset::ASCIICharset.s_to_i(secret_string)
    points = Polynomial.points_from_secret(secret_int,
                                           share_threshold,
                                           num_shares)

    points.map do |point|
      Share.new(point).to_s(Math.log10(points.length) + 1)
    end
  end

  # Recover a secret with an array of string shares generated with
  # {#split}.
  #
  # Example
  #
  #   SecretSharing.reconstruct ["1-1e489c32507823aa", "2-1c9134c644739461"]
  #   # => "secret"
  #
  # @param raw_shares [Array] Shares (array of strings) to recover the secret
  #
  # @return [String] Recovered secret in a string representation.
  def reconstruct(raw_shares)
    shares = raw_shares.map { |raw_share| Share.from_string raw_share }
    points = shares.map(&:point)
    secret_int = Polynomial.modular_lagrange_interpolation(points)
    Charset::ASCIICharset.i_to_s(secret_int)
  end
end
