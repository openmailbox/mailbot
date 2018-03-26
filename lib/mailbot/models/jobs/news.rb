require 'rss'

module Mailbot
  module Models
    class News < Job
      def perform
        feed             = Mailbot::RSS::Steam.new
        last             = (self.last_run_at || DateTime.now).utc
        channel_id       = details['discord_channel_id']
        self.last_run_at = DateTime.now

        feed.refresh!

        feed.items_since(last).each do |item|
          Mailbot.logger.info("Sending news story #{item.link} to channel #{channel_id}")

          discord.send_message(channel_id, formatted_message(item))

          sleep(0.5) # don't flood
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
    end
  end
end
