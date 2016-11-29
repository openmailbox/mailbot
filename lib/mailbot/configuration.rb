require 'yaml'

module Mailbot
  class Configuration
    SETTINGS_FILE = Mailbot.root + '/config/settings.yml'

    attr_reader :settings

    def initialize
      @settings = YAML.load_file(SETTINGS_FILE)
    end
  end
end
