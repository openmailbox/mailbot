require 'yaml'

module Mailbot
  class Configuration
    SETTINGS_FILE = Mailbot.root + '/config/settings.yml'

    attr_accessor :twitch_api_token, :twitch_username

    def initialize
      hash = YAML.load_file(SETTINGS_FILE)

      @twitch_username = hash['twitch']['username']
    end
  end
end
