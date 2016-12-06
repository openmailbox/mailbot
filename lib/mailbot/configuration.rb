require 'yaml'

module Mailbot
  class Configuration
    SETTINGS_FILE = Mailbot.root + '/config/settings.yml'

    attr_accessor :log_file, :twitch_api_token, :twitch_username

    def initialize
      hash = YAML.load_file(SETTINGS_FILE)

      @log_file        = hash['log_file'] || STDOUT
      @twitch_username = hash['twitch']['username']
    end
  end
end
