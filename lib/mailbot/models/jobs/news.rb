module Mailbot
  module Models
    class News < Job
      STEAM_RSS = 'http://store.steampowered.com/feeds/news.xml'.freeze

      def perform
        feed = nil

        open(STEAM_RSS) { |rss| feed = RSS::Parser.parse(rss, false) }

        latest = feed.items&.first

        return unless latest
        return if latest.link == details['last_message']

        discord.send_message(details['discord_channel_id'], formatted_message(latest))

        self.details['last_message'] = latest.link
        self.last_run_at = Time.now.utc

        save!
      end

      private

      def discord
        @discord ||= Mailbot.instance.discord.bot
      end

      # @param [RSS::RDF::Item] item
      def formatted_message(item)
        "#{item.title} - #{item.link}"
      end
    end
  end
end
