# == Schema Information
#
# Table name: users
#
#  id         :bigint(8)        not null, primary key
#  email      :string
#  admin      :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ApplicationRecord
  has_one :discord_identity, dependent: :destroy

  def self.find_or_create_by_auth_hash(auth_hash)
    provider = auth_hash[:provider]

    case provider
    when 'developer'
      user = User.find_or_create_by!(email: auth_hash.dig(:info, :email))
    when 'discord'
      find_or_create_by_discord(auth_hash)
    else
      raise 'Unrecognized OmniAuth provider.'
    end
  end

  def self.find_or_create_by_discord(auth_hash)
    identity = DiscordIdentity.find_by(uid: auth_hash[:uid])

    if identity.nil?
      identity = DiscordIdentity.new(uid:           auth_hash[:uid],
                                     name:          auth_hash.dig(:info, :name),
                                     email:         auth_hash.dig(:info, :email),
                                     image_url:     auth_hash.dig(:info, :image),
                                     username:      auth_hash.dig(:extra, :raw_info, :username),
                                     discriminator: auth_hash.dig(:extra, :raw_info, :discriminator),
                                     mfa_enabled:   auth_hash.dig(:extra, :raw_info, :mfa_enabled),
                                     extra_id:      auth_hash.dig(:extra, :raw_info, :id),
                                     avatar:        auth_hash.dig(:extra, :raw_info, :avatar))
    end

    identity.token         = auth_hash.dig(:credentials, :token)
    identity.refresh_token = auth_hash.dig(:credentials, :refresh_token)
    identity.expires_at    = Time.at(auth_hash.dig(:credentials, :expires_at))
    identity.expires       = auth_hash.dig(:credentials, :expires)

    identity.build_user unless identity.user
    identity.save if identity.changed?

    identity.user
  end

  def name
    discord_identity&.name || email
  end
end
