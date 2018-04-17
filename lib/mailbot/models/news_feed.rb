# == Schema Information
#
# Table name: news_feeds
#
#  id            :integer          not null, primary key
#  title         :string
#  link          :string
#  decription    :string
#  reader_class  :string
#  last_build_at :datetime
#
# Indexes
#
#  index_news_feeds_on_link  (link)
#

module Mailbot
  module Models
    # TODO: Update NewsFeed fields with RSS-provided data
    class NewsFeed < ActiveRecord::Base
      has_many :rss_items
      has_many :news_feed_subscriptions

      validate :reader_must_exist

      # @param [Mailbot::Models::RssItem] item The item to be formatted
      #
      # @return [String] The formatted message
      def format_message(item)
        reader.format_message(item.to_feed_item)
      end

      def reader
        Mailbot.logger.warn("No RSS reader for #{self}") unless reader_class

        @reader ||= reader_class&.constantize&.new
      end

      # @return [Array<Mailbot::Models::RssItem>] Any newly created feed items
      def refresh!
        latest    = rss_items.order('published_at DESC').first
        new_items = []

        return unless reader

        reader.refresh!

        reader.items.each do |item|
          existing = rss_items.find_by(guid: item.guid)

          next if existing
          next if latest && latest.published_at > item.published_at

          new_items << rss_items.create!(guid:         item.guid,
                                         title:        item.title,
                                         published_at: item.published_at,
                                         link:         item.link,
                                         description:  item.description)
        end

        new_items
      end

      private

      def reader_must_exist
        unless Mailbot::RSS.const_defined?(reader_class)
          errors.add(:reader_class, 'must be a valid reader class')
        end
      end
    end
  end
end
