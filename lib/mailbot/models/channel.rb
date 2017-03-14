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
    class Channel < ActiveRecord::Base
      def send_message(message)
        twitch.send_string(name, message)
      end

      private

      def twitch
        Mailbot.instance.twitch
      end
    end
  end
end
