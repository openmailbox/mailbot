require 'mailbot/models/channel'
require 'mailbot/models/channel_membership'
require 'mailbot/models/community'
require 'mailbot/models/game'
require 'mailbot/models/job'
require 'mailbot/models/platform'
require 'mailbot/models/review'
require 'mailbot/models/user'
require 'mailbot/models/jobs/kadgar'

module Mailbot
  module Models
    ActiveRecord::Base.logger = Mailbot.logger

    configuration = YAML.load_file(Mailbot.root + '/config/database.yml')

    ActiveRecord::Base.establish_connection(configuration[Mailbot.env])
  end
end
