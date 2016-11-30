Thread.abort_on_exception = true

module Mailbot
  VERSION = '0.1.0'

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield configuration
  end

  def self.root
    @root ||= File.expand_path('../../', __FILE__)
  end

  def self.start
    Mailbot::Bot.new.run
  end

  def self.version
    VERSION
  end
end

require 'mailbot/bot'
require 'mailbot/configuration'
require 'mailbot/twitch'
