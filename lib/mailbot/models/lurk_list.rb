# == Schema Information
#
# Table name: lurk_lists
#
#  id                 :integer          not null, primary key
#  nickname           :string
#  discord_channel_id :string
#  guild_id           :string
#  twitch_names       :text
#

module Mailbot
  module Models
    class LurkList < ActiveRecord::Base
      serialize :twitch_names, Array

      validates :nickname,           presence: true
      validates :discord_channel_id, presence: true
      validates :guild_id,           presence: true

      validate :twitch_names_present

      private

      def twitch_names_present
        if twitch_names.length < 1
          errors.add(:twitch_names, 'must contain at least one name')
        end
      end
    end
  end
end
