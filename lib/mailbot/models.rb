require 'mailbot/models/user'

module Mailbot
  module Models
    ActiveRecord::Base.logger = Mailbot.logger

    configuration = YAML.load_file(Mailbot.root + '/config/database.yml')

    ActiveRecord::Base.establish_connection(configuration)
  end
end
