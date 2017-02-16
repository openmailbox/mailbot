require 'logger'

Thread.abort_on_exception = true

module Mailbot
  VERSION = '0.1.0'

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield configuration
  end

  def self.env
    @env ||= (ENV['MAILBOT_ENV'] || 'development')
  end

  def self.logger
    @logger ||= Logger.new(STDOUT)
  end

  def self.root
    @root ||= File.expand_path('../../', __FILE__)
  end

  def self.start
    Mailbot.logger.info "Starting bot in #{Mailbot.env} environment..."
    Mailbot::Bot.new.run
  end

  def self.version
    VERSION
  end
end

require 'mailbot/bot'
require 'mailbot/commands'
require 'mailbot/configuration'
require 'mailbot/twitch'
require 'mailbot/user'
