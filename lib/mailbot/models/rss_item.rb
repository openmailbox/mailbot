module Mailbot
  module Models
    class RssItem < ActiveRecord::Base
      belongs_to :news_feed
    end
  end
end
