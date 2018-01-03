# == Schema Information
#
# Table name: communities
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  platform_id :integer
#  user_id     :integer
#  created_at  :datetime
#

module Mailbot
  module Models
    # Represents a Discord community.
    class Community < ActiveRecord::Base
      belongs_to :platform
      belongs_to :user

      has_many :rust_servers, as: :service

      # Send a message to a Discord server.
      #
      # @param [String] message the message to send
      # @param [Hash] options
      # @option options [Discordrb::Channel] :channel the channel to send the message on
      def send_message(message, options = {})
        options[:channel].send_message(message)
      end
    end
  end
end
