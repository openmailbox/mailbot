module Mailbot
  module Models
    # TODO: Update NewsFeed fields with RSS-provided data
    class NewsFeed < ActiveRecord::Base
      has_many :rss_items
    end
  end
end
