[![Gem Version](https://badge.fury.io/rb/secret_sharing.svg)](http://badge.fury.io/rb/secret_sharing)
[![Build Status](https://travis-ci.org/duse-io/secret_sharing_ruby.svg?branch=master)](https://travis-ci.org/duse-io/secret_sharing_ruby)
[![Coverage Status](https://coveralls.io/repos/duse-io/secret_sharing_ruby/badge.svg?branch=master)](https://coveralls.io/r/duse-io/secret_sharing_ruby?branch=master)
[![Code Climate](https://codeclimate.com/github/duse-io/secret_sharing_ruby/badges/gpa.svg)](https://codeclimate.com/github/duse-io/secret_sharing_ruby)
[![Inline docs](http://inch-ci.org/github/duse-io/secret_sharing_ruby.svg?branch=master)](http://inch-ci.org/github/duse-io/secret_sharing_ruby)

# secret_sharing

> **Warning:** This implementation has not been tested in production nor has it
> been examined by a security audit. All uses are your own responsibility.

A ruby implementation of shamir's secret sharing.

## Installation

Add this line to your application's Gemfile:

    gem 'secret_sharing'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install secret_sharing

## Implementation details

This implementation of shamir's secret sharing has initially been developed to
be used in [duse](https://duse.io/), however, it is designed to be used in any
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

## Usage

	require 'secret_sharing'
	shares = SecretSharing.split_secret('my secret', 2, 3)
	# => ["1-437b3d6cce8e7b77adb75", "2-86f673fa74e31127903f6", "3-ca71aa881b37a6d772c77"]
	length = shares.length
	# => 3
	secret = SecretSharing.recover_secret(shares[0..1])
	# => 'my secret'

## Contributing

1. Fork it ( https://github.com/duse-io/secret_sharing_ruby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
