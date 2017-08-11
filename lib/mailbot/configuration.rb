require 'logger'
require 'ostruct'
require 'yaml'

module Mailbot
  class Configuration
    SECRETS_FILE  = Mailbot.root + '/config/secrets.yml'
    SETTINGS_FILE = Mailbot.root + '/config/settings.yml'

    attr_reader :twitch, :discord, :log_file

    def initialize
      settings  = load_file(SETTINGS_FILE)
      secrets   = load_file(SECRETS_FILE)
      @twitch   = OpenStruct.new
      @discord  = OpenStruct.new
      @log_file = STDOUT

      [settings, secrets].each do |hash|
        hash['twitch'].each do |key, value|
          twitch.send("#{key}=", value)
        end

        hash['discord'].each do |key, value|
          discord.send("#{key}=", value)
        end
      end
    end

    def log_file=(new_file)
      @log_file = new_file
      initialize_logger
      nil
    end

    def logger
      @logger ||= initialize_logger
    end

    private

    def initialize_logger
      STDOUT.sync = true if Mailbot.env == 'production'
      @logger = Logger.new(log_file)
    end

    def load_file(file)
      YAML.load_file(file)
    rescue Errno::ENOENT
      Mailbot.logger.warn "Unable to load #{file}."
      {}
    end
  end
end
