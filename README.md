[![Gem Version](https://badge.fury.io/rb/secret_sharing.svg)](http://badge.fury.io/rb/secret_sharing)
[![Build Status](https://travis-ci.org/duse-io/secret_sharing_ruby.svg?branch=master)](https://travis-ci.org/duse-io/secret_sharing_ruby)
[![Coverage Status](https://coveralls.io/repos/duse-io/secret_sharing_ruby/badge.svg?branch=master)](https://coveralls.io/r/duse-io/secret_sharing_ruby?branch=master)
[![Code Climate](https://codeclimate.com/github/duse-io/secret_sharing_ruby/badges/gpa.svg)](https://codeclimate.com/github/duse-io/secret_sharing_ruby)
[![Inline docs](http://inch-ci.org/github/duse-io/secret_sharing_ruby.svg?branch=master)](http://inch-ci.org/github/duse-io/secret_sharing_ruby)

# secret_sharing

> **Warning:** This implementation has not been tested in production nor has it
> been examined by a security audit. All uses are your own responsibility.

A ruby implementation of [Shamir's Secret
Sharing](http://en.wikipedia.org/wiki/Shamir%27s_Secret_Sharing).

## Installation

Add this line to your application's Gemfile:

    gem 'secret_sharing'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install secret_sharing

## Implementation details

This implementation of Shamir's Secret Sharing has initially been developed to
be used in [duse](http://duse.io/), however, it is designed to be used in any
other context just as well.

The representation of a share is simply `x-hex(y)`. We chose this
representation, mainly to make it easier for this library to become compatible
with other implementations, if we choose to.

For better approximation and equal length of the resulting shares, a zero
padding has been added. For example, if there are ten or more shares, then all
single digit shares have a prepending zero.

* `01-574060c9`
* `02-1fe7479f`
* ...
* `10-651e7e4b`

Also, when generating a random polynomial, we make sure the coefficients are
random, but never zero. If we would allow the coefficients to be zero, it could
result in a lower threshold than intended. For example, if the threshold is
three, then the degree of the polynomial would be two so in the form of
`f(x)=a0 + a1*x + a2*x^2`. If `a2` would be zero than the polynomial would be
of dergree one, which would result in a real threshold of two rather than
three.

## Usage

	require 'secret_sharing'
	shares = SecretSharing.split('my secret', 2, 3)
	# => ["1-437b3d6cce8e7b77adb75", "2-86f673fa74e31127903f6", "3-ca71aa881b37a6d772c77"]
	secret = SecretSharing.reconstruct(shares[0..1]) # two shares are enough to reconstruct!
	# => 'my secret'

[Further documentation on
rubydoc](http://www.rubydoc.info/github/duse-io/secret_sharing_ruby/master/SecretSharing).

## Rubies

Tested on

* Ruby MRI
* JRuby

## Contributing

1. Fork it ( https://github.com/duse-io/secret_sharing_ruby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
