# == Schema Information
#
# Table name: users
#
#  id   :integer          not null, primary key
#  name :string(255)
#

module Mailbot
  module Models
    class User < ActiveRecord::Base
    end
  end
end
