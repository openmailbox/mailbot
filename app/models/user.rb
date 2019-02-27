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
    User.new
  end
end
