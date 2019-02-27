module OmniauthHelpers
  OmniAuth.config.test_mode = true

  def mock_discord_auth
    hash = {provider: "discord",
            uid: "1234567890",
            info: {
              name: "open_mailbox",
              email: nil,
              image: "https://cdn.discordapp.com/avatars/1234567890/37ca0aef548bce52d2df30acea492f2d"
            },
            credentials: {
              token: "<TOKEN>",
              refresh_token: "<REFRESH_TOKEN>",
              expires_at: Time.now.to_i + 30,
              expires: true
            },
            extra: {
              raw_info: {
                username: "open_mailbox",
                discriminator: "2035",
                mfa_enabled: true,
                id: "1234567890",
                avatar: "37ca0aef548bce52d2df30acea492f2d"
              }
            }
    }

    OmniAuth.config.mock_auth[:discord] = OmniAuth::AuthHash.new(hash)
  end

  def clear_discord_mock
    OmniAuth.config.mock_auth[:discord] = nil
  end
end
