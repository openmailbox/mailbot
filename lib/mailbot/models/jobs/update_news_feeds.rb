module Mailbot
  module Models
    class UpdateNewsFeeds < Job
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
        unless news_feed
          Mailbot.logger.warn("No NewsFeed for #{self}")
          return
        end

        news_feed.refresh!
      end

      # @param [Mailbot::Models::RssItem] item
      def formatted_message(item)
        "#{Sanitize.fragment(item.description)} - #{item.link}"
      end

      def news_feed
        @news_feed ||= NewsFeed.find_by(id: details['news_feed_id'])
      end

      # @param [Array<Mailbot::Models::RssItem>] new_items The items to send to Discord
      def update_discord(new_items)
        channel_id = details['discord_channel_id']

        unless channel_id
          Mailbot.logger.warn("No Discord channel ID for #{self}.")
          return
        end

        new_items.each do |item|
          discord.send_message(channel_id, news_feed.format_message(item), false, item.to_discord_embed)
        end
      end
    end
  end
end
