require "secret_sharing/version"
require "secret_sharing/point"
require "secret_sharing/polynomial"
require "secret_sharing/prime"
require "secret_sharing/charset"

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
  #   # => [<SecretSharing::Point @x=1, @y=2182165759373353898>, <SecretSharing::Point @x=2, @y=2058484530841621601>, <SecretSharing::Point @x=3, @y=1934803302309889304>]
  #
  # @param secret_string [String] Secret to split.
  # @param share_threshold [Integer] Number of shares to recover the secret.
  # @param num_shares [Integer] Total number of shares to generate.
  #
  # @return [Array<Point>] Array of shares that can be used to recover the secret.
  def split(secret_string, share_threshold, num_shares)
    secret_int = Charset::ASCIICharset.s_to_i(secret_string)

    Polynomial.points_from_secret(
      secret_int,
      share_threshold,
      num_shares
    )
  end

  # Recover a secret with an array of string shares generated with
  # {#split}.
  #
  # Example
  #
  #   point1 = SecretSharing::Point.new(1, 2182165759373353898)
  #   point2 = SecretSharing::Point.new(2, 2058484530841621601)
  #   SecretSharing.combine [point1, point2]
  #   # => "secret"
  #
  # @param points [Array<Point>] Points to recover the secret through
  # interpolation
  #
  # @return [String] Recovered secret in a string representation.
  def combine(points)
    secret_int = Polynomial.modular_lagrange_interpolation(points)
    Charset::ASCIICharset.i_to_s(secret_int)
  end
end
