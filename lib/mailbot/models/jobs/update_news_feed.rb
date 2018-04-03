module Mailbot
  module Models
    class UpdateNewsFeed < Job
      def perform
        self.last_run_at = DateTime.now.utc

        new_items = find_or_create_items!

        save!
      end

      private

      # Fetch the RSS feed and save any new items
      #
      # @return [Mailbot::Models::RssItem] The newly created RSS items
      def find_or_create_items!
        new_items = []
        news_feed = NewsFeed.find_by(id: details['news_feed_id'])
        reader    = news_feed&.reader_class&.constantize&.new

        unless news_feed
          Mailbot.logger.warn("No news feed with id = #{details['news_feed_id']}")
          return
        end

        reader.refresh!

        reader.items.each do |item|
          existing = news_feed.rss_items.find_by(guid: item.guid)

          next if existing

          new_items << news_feed.rss_items.create!(guid:         item.guid,
                                                   title:        item.title,
                                                   published_at: item.published_at,
                                                   description:  item.description)
        end

        new_items
      end
    end
  end
end
