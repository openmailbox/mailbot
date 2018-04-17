# == Schema Information
#
# Table name: news_feed_subscriptions
#
#  id                 :integer          not null, primary key
#  news_feed_id       :integer
#  discord_channel_id :string
#
# Indexes
#
#  index_news_feed_subscriptions_on_news_feed_id  (news_feed_id)
#

module Mailbot
  module Models
    class NewsFeedSubscription < ActiveRecord::Base
      belongs_to :news_feed
    end
  end
end
