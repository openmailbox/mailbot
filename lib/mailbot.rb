module Mailbot
  def self.config
    @config ||= Configuration.new
  end

  def self.root
    @root ||= File.expand_path('../../', __FILE__)
  end
end

require 'mailbot/channel'
require 'mailbot/configuration'
require 'mailbot/twitch'
