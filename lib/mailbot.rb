require 'active_record'
require 'logger'
require 'httparty'
require 'htmlentities'
require 'json'
require 'time'

Thread.abort_on_exception = true

module Mailbot
  VERSION = '0.2.0'

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield configuration
  end

  def self.env
    @env ||= (ENV['MAILBOT_ENV'] || 'development')
  end

  def self.instance
    @bot
  end

  def self.logger
    STDOUT.sync = true if Mailbot.env == 'production'
    @logger ||= Logger.new(STDOUT)
  end

  def self.root
    @root ||= File.expand_path('../../', __FILE__)
  end

  def self.start
    Mailbot.logger.info "Starting bot in #{Mailbot.env} environment..."
    @bot = Mailbot::Bot.new
    @bot.run
  end

  def self.stop
    @bot.stop
  end

  def self.version
    VERSION
  end
end

require 'mailbot/bot'
require 'mailbot/commands'
require 'mailbot/context'
require 'mailbot/configuration'
require 'mailbot/discord'
require 'mailbot/twitch'
require 'mailbot/twitch/parser'
require 'mailbot/models'
