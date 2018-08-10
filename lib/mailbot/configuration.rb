require 'logger'
require 'ostruct'
require 'yaml'

module Mailbot
  class Configuration
    SECRETS_FILE  = Mailbot.root + '/config/secrets.yml'
    SETTINGS_FILE = Mailbot.root + '/config/settings.yml'
    LOG_FILE      = Mailbot.root + '/log/mailbot.log'

    class MultiIO
      def initialize(*targets)
        @targets = targets
      end

      def write(*args)
        @targets.each { |t| t.write(*args) }
      end

      def close
        @targets.each(&:close)
      end
    end

    attr_accessor :enable_twitch, :enable_discord, :enable_scheduler
    attr_reader :twitch, :discord, :log_file, :api_token

    def initialize
      settings          = load_file(SETTINGS_FILE)
      secrets           = load_file(SECRETS_FILE)
      @api_token        = secrets['api_token']
      @twitch           = OpenStruct.new
      @discord          = OpenStruct.new
      @enable_twitch    = false
      @enable_discord   = false
      @enable_scheduler = false


      [settings, secrets].each do |hash|
        hash['twitch'].each do |key, value|
          twitch.send("#{key}=", value)
        end

        hash['discord'].each do |key, value|
          discord.send("#{key}=", value)
        end
      end
    end

    def logger
      @logger ||= initialize_logger
    end

    private

    def initialize_logger
      STDOUT.sync = true if Mailbot.env == 'production'
      if Mailbot.env == 'test'
        @logger = Logger.new(nil)
      else
        log_file = File.open(LOG_FILE, 'a')
        log_file.sync = true
        @logger = Logger.new(MultiIO.new(STDOUT, log_file))
      end
    end

    def load_file(file)
      YAML.load_file(file)
    rescue Errno::ENOENT
      puts "ERROR: Unable to load #{file}."
      raise
    end
  end
end
