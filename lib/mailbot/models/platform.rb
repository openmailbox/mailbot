# == Schema Information
#
# Table name: platforms
#
#  id   :integer          not null, primary key
#  name :string
#

module Mailbot
  module Models
    class Platform < ActiveRecord::Base
      has_many :communities
    end
  end
end
