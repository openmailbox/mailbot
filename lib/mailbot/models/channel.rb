# == Schema Information
#
# Table name: channels
#
#  id       :integer          not null, primary key
#  name     :string(255)
#  owner_id :integer
#

module Mailbot
  module Models
    # Represents a Twitch channel.
    class Channel < ActiveRecord::Base
      has_many :channel_memberships

      def send_message(message, options = {})
        twitch.send_string(name, message)
      end

      private

      def twitch
        Mailbot.instance.twitch
      end
    end
  end
end
