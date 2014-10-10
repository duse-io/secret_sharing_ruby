require 'spec_helper'

describe SecretSharing do
  context '#split_secret' do
    # SecretSharing.split_secret("correct horse battery staple", 2, 3)
  end

  context '#recover_secret' do
    secrets = SecretSharing.split_secret("correct horse battery staple", 2, 3)
    p SecretSharing.recover_secret(secrets[0..1])
  end
end

