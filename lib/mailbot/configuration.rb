require 'ostruct'
require 'yaml'

module Mailbot
  class Configuration
    SECRETS_FILE  = Mailbot.root + '/config/secrets.yml'
    SETTINGS_FILE = Mailbot.root + '/config/settings.yml'

    attr_reader :twitch

    def initialize
      settings = YAML.load_file(SETTINGS_FILE)
      @twitch  = OpenStruct.new

      [settings, secrets].each do |hash|
        hash['twitch'].each do |key, value|
          twitch.send("#{key}=", value)
        end
      end
    end

    private

    def secrets
      YAML.load_file(SECRETS_FILE)
    rescue Errno::ENOENT
      Mailbot.logger.warn 'WARNING: Unable to load config/secrets.yml.'
      {}
    end
  end
end
