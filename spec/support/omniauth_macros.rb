# in spec/support/omniauth_macros.rb
module OmniauthMacros
  def twitter_mock_auth_hash
    # The mock_auth configuration allows you to set per-provider (or default)
    # authentication hashes to return during integration testing.
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
      provider: 'twitter',
      uid: '123456',
      info: { email: nil }
    })
  end

  def twitter_mock_invalid_auth_hash
    OmniAuth.config.mock_auth[:twitter] = :invalid_credentials
  end

  def facebook_mock_auth_hash(hash = {})
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
      provider: 'facebook',
      uid: '123456',
      info: { email: 'oath2@email.com' }
    }).merge(hash)
  end

  def facebook_mock_invalid_auth_hash
    OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
  end
end
