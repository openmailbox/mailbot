# == Schema Information
#
# Table name: channel_memberships
#
#  id              :integer          not null, primary key
#  channel_id      :integer
#  user_id         :integer
#  points          :integer          default(0)
#  last_message_at :datetime
#

module Mailbot
  module Models
    class ChannelMembership < ActiveRecord::Base
      belongs_to :user
      belongs_to :channel

      validates :user_id, presence: true, uniqueness: { scope: :channel_id }
      validates :channel_id, presence: true
    end
  end
end
