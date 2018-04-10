module Mailbot
  module Models
    # TODO: Update NewsFeed fields with RSS-provided data
    class NewsFeed < ActiveRecord::Base
      has_many :rss_items

      # @param [Mailbot::Models::RssItem] item The item to be formatted
      #
      # @return [String] The formatted message
      def format_message(item)
        reader.format_message(item)
      end

      def reader
        Mailbot.logger.warn("No RSS reader for #{self}") unless reader_class

        @reader ||= reader_class&.constantize&.new
      end

      # @return [Array<Mailbot::Models::RssItem>] Any newly created feed items
      def refresh!
        new_items = []

        return unless reader

        reader.refresh!

        reader.items.each do |item|
          existing = rss_items.find_by(guid: item.guid)

          next if existing

          new_items << rss_items.create!(guid:         item.guid,
                                         title:        item.title,
                                         published_at: item.published_at,
                                         link:         item.link,
                                         description:  item.description)
        end

        new_items
      end
    end
  end
end
