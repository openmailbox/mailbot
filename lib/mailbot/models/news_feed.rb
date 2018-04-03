module Mailbot
  module Models
    class NewsFeed < ActiveRecord::Base
      has_many :rss_items
    end
  end
end
