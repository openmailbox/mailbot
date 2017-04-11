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

      # Makes this quack like a Channel. Mailbot::Discord sends whatever the return value was.
      def send_message(message)
        message
      end
    end
  end
end
