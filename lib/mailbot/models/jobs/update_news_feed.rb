module Mailbot
  module Models
    class UpdateNewsFeed < Job
      def perform
        self.last_run_at = DateTime.now.utc

        new_items = find_or_create_items!
        update_discord(new_items)

        save!
      end

      private

      # Fetch the RSS feed and save any new items
      #
      # @return [Array<Mailbot::Models::RssItem>] The newly created RSS items
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

      # @param [Mailbot::Models::RssItem] item
      def formatted_message(item)
        "#{Sanitize.fragment(item.description)} - #{item.link}"
      end

      # @param [Array<Mailbot::Models::RssItem>] new_items The items to send to Discord
      def update_discord(new_items)
        channel_id = details['discord_channel_id']

        unless channel_id
          Mailbot.logger.warn("No Discord channel ID for #{self}.")
          return
        end

        new_items.each do |item|
          discord.send_message(channel_id, formatted_message(item))
        end
      end
    end
  end
end
