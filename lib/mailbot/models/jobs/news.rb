require 'rss'

module Mailbot
  module Models
    class News < Job
      READERS = [Mailbot::RSS::Steam, Mailbot::RSS::Newegg]

      def perform
        last             = (self.last_run_at || DateTime.now).utc
        self.last_run_at = DateTime.now

        READERS.each do |klass|
          update_feed(last, klass.new)
        end

        save!
      end

      private

      def discord
        @discord ||= Mailbot.instance.discord.bot
      end

      # @param [Mailbot::RSS::FeedItem] item
      def formatted_message(item)
        "#{Sanitize.fragment(item.description)} - #{item.link}"
      end

      # @param [DateTime] begin_at Earliest time to search for stories
      # @param [Mailbot::RSS::Feed] feed The news feed
      def update_feed(begin_at, feed)
        channel_id = details['discord_channel_id']

        feed.refresh!

        feed.filtered_items_since(begin_at).each do |item|
          Mailbot.logger.info("Sending news story #{item.link} to channel #{channel_id}")

          discord.send_message(channel_id, formatted_message(item))

          sleep(0.5) # don't flood
        end
      end
    end
  end
end
