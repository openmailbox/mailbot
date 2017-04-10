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
    class Community < ActiveRecord::Base
      belongs_to :platform
      belongs_to :user
    end
  end
end
