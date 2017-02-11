require 'set'

module Mailbot
  module Models
    class User < ActiveRecord::Base
      #attr_reader :name

      #def self.find_or_initialize(name)
      #  user = list.find do |existing|
      #    existing.name == name
      #  end

      #  unless user
      #    user = User.new(name)
      #    list << user
      #  end

      #  user
      #end

      #def self.list
      #  @list ||= Set.new
      #end

      #private

      #def initialize(name)
      #  @name = name
      #end
    end
  end
end
