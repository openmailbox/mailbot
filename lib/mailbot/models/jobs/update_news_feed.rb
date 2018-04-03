module Mailbot
  module Models
    class UpdateNewsFeed < Job
      def perform
        self.last_run_at = DateTime.now.utc

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

          news_feed.rss_items.create!(guid:         item.guid,
                                      title:        item.title,
                                      published_at: item.published_at,
                                      description:  item.description)
        end

        save!
      end
    end
  end
end
