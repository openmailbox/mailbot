# == Schema Information
#
# Table name: platforms
#
#  id   :integer          not null, primary key
#  name :string(255)
#

module Mailbot
  module Models
    class Platform < ActiveRecord::Base
      has_many :communities
    end
  end
end
