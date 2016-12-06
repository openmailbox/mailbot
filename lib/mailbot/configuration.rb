require 'ostruct'
require 'yaml'

module Mailbot
  class Configuration
    SETTINGS_FILE = Mailbot.root + '/config/settings.yml'

    attr_reader :log_file, :twitch

    def initialize
      hash = YAML.load_file(SETTINGS_FILE)

      @twitch   = OpenStruct.new
      @log_file = hash['log_file'] || STDOUT

      hash['twitch'].each do |key, value|
        twitch.send("#{key}=", value)
      end
    end
  end
end
