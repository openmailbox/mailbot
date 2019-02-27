creds = Rails.application.credentials

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :discord, creds.discord[:client_id], creds.discord[:client_secret], scope: 'identify guilds'
end
