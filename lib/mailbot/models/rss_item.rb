# == Schema Information
#
# Table name: rss_items
#
#  id           :integer          not null, primary key
#  guid         :string
#  title        :string
#  published_at :datetime
#  link         :string
#  description  :string
#  news_feed_id :integer
#
# Indexes
#
#  index_rss_items_on_guid          (guid)
#  index_rss_items_on_news_feed_id  (news_feed_id)
#

module Mailbot
  module Models
    class RssItem < ActiveRecord::Base
      belongs_to :news_feed

      # @return [Discordrb::Webhooks::Embed] The embeddable message
      def to_discord_embed
        news_feed.reader&.discord_embed(to_feed_item)
      end

      # @return [Mailbot::RSS::FeedItem] a struct representing the RSS item
      def to_feed_item
        Mailbot::RSS::FeedItem.new(title, link, guid, published_at, description)
      end
    end
  end
end
