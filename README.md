[![Build Status](https://travis-ci.org/flower-pot/secret_sharing.svg)](https://travis-ci.org/flower-pot/secret_sharing)
[![Coverage Status](https://img.shields.io/coveralls/flower-pot/secret_sharing.svg)](https://coveralls.io/r/flower-pot/secret_sharing)
[![Code Climate](https://codeclimate.com/github/flower-pot/secret_sharing/badges/gpa.svg)](https://codeclimate.com/github/flower-pot/secret_sharing)

# SecretSharing

A ruby implementation of shamir's secret sharing.

## Installation

Add this line to your application's Gemfile:

    gem 'secret_sharing'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install secret_sharing

## Usage

	require 'secret_sharing'
	shares = SecretSharing.split_secret('secret', 2, 3) # => [...]
	length = shares.length # => 3
	secret = SecretSharing.recover_secret(shares[0..1]) # => 'my secret'

## Contributing

1. Fork it ( https://github.com/flower-pot/secret_sharing/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
