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
    configuration.logger
  end

  def self.root
    @root ||= File.expand_path('../../', __FILE__)
  end

  # @param [OpenStuct] options The parsed command-line arguments
  def self.start(options)
    configure do |config|
      config.enable_twitch = options.twitch
      config.enable_discord = options.discord
      config.enable_scheduler = options.scheduler
    end

    logger.info "Starting bot in #{Mailbot.env} environment..."
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

require 'bundler/setup'
Bundler.require(:default, Mailbot.env)

if ['development', 'test'].include?(Mailbot.env)
  Dotenv.load
end

Raven.configure do |config|
  config.dsn = ENV['MAILBOT_SENTRY_DSN']
  config.current_environment = Mailbot.env
end

require 'mailbot/bot'
require 'mailbot/commands'
require 'mailbot/connection'
require 'mailbot/context'
require 'mailbot/configuration'
require 'mailbot/discord'
require 'mailbot/nlp'
require 'mailbot/scheduler'
require 'mailbot/twitch'
require 'mailbot/twitch/parser'
require 'mailbot/rss'
require 'mailbot/models'
require 'mailbot/web_client'
