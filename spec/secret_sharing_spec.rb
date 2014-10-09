require 'spec_helper'

describe SecretSharing do
  context '#split_secret' do
    p SecretSharing.split_secret("correct horse battery staple", 2, 3)
  end

  context '#recover_secret' do

  end
end

