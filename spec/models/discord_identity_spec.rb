# == Schema Information
#
# Table name: discord_identities
#
#  id            :bigint(8)        not null, primary key
#  avatar        :string
#  bot           :boolean          default(FALSE)
#  discriminator :string
#  email         :string
#  expires       :boolean
#  expires_at    :datetime
#  image_url     :string
#  mfa_enabled   :boolean
#  name          :string
#  refresh_token :string
#  token         :string
#  uid           :string
#  username      :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  extra_id      :string
#  user_id       :bigint(8)
#
# Indexes
#
#  index_discord_identities_on_uid      (uid)
#  index_discord_identities_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

require 'rails_helper'

RSpec.describe DiscordIdentity, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
