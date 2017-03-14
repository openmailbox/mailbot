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
    end
  end
end
