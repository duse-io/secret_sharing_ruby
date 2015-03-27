[![Gem Version](https://badge.fury.io/rb/secret_sharing.svg)](http://badge.fury.io/rb/secret_sharing)
[![Build Status](https://travis-ci.org/duse-io/secret_sharing_ruby.svg?branch=master)](https://travis-ci.org/duse-io/secret_sharing_ruby)
[![Coverage Status](https://coveralls.io/repos/duse-io/secret_sharing_ruby/badge.svg?branch=master)](https://coveralls.io/r/duse-io/secret_sharing_ruby?branch=master)
[![Code Climate](https://codeclimate.com/github/duse-io/secret_sharing_ruby/badges/gpa.svg)](https://codeclimate.com/github/duse-io/secret_sharing_ruby)
[![Inline docs](http://inch-ci.org/github/duse-io/secret_sharing_ruby.svg?branch=master)](http://inch-ci.org/github/duse-io/secret_sharing_ruby)

# SecretSharing

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

## Usage

	require 'secret_sharing'
	shares = SecretSharing.split_secret('secret', 2, 3) # => [...]
	length = shares.length # => 3
	secret = SecretSharing.recover_secret(shares[0..1]) # => 'my secret'

This implementation can also handle non-ascii characters, however, the charset
will be visible in the calculated shares. Thus splitting ascii only strings is
"more" secure. (but always remember, shamir's secret sharing alone is not
secure)

## Compatible libraries

Since this implementation is special in some ways most [Shamir’s Secret
Sharing](http://de.wikipedia.org/wiki/Shamir%E2%80%99s_Secret_Sharing)
libraries are not compatible. The only library that is compatible as of now is
[duse-io/secret-sharing-dart](https://github.com/duse-io/secret-sharing-dart).

We do have [integration
tests](https://github.com/duse-io/lib-integration-tests) that make sure the
libraries work with each other.

## Contributing

1. Fork it ( https://github.com/duse-io/secret_sharing/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
