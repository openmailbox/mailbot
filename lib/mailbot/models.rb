require 'mailbot/models/channel'
require 'mailbot/models/channel_membership'
require 'mailbot/models/community'
require 'mailbot/models/job'
require 'mailbot/models/news_feed'
require 'mailbot/models/news_feed_subscription'
require 'mailbot/models/platform'
require 'mailbot/models/rss_item'
require 'mailbot/models/rust_server'
require 'mailbot/models/user'
require 'mailbot/models/jobs/kadgar'
require 'mailbot/models/jobs/update_news_feed'

module Mailbot
  module Models
    ActiveRecord::Base.logger = Mailbot.logger

    if Mailbot.env == 'production'
      ActiveRecord::Base.logger.level = :info
    end

    configuration = YAML.load_file(Mailbot.root + '/config/database.yml')

    ActiveRecord::Base.establish_connection(configuration[Mailbot.env])
  end
end
