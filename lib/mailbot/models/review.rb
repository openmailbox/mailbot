# == Schema Information
#
# Table name: reviews
#
#  id         :integer          not null, primary key
#  rating     :integer
#  user_id    :integer
#  game_id    :integer
#  created_at :datetime
#

module Mailbot
  module Models
    class Review < ActiveRecord::Base
      belongs_to :user
      belongs_to :game
    end
  end
end
