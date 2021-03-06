# == Schema Information
#
# Table name: users
#
#  id   :integer          not null, primary key
#  name :string
#

module Mailbot
  module Models
    class User < ActiveRecord::Base
      has_many :channel_memberships
    end
  end
end
