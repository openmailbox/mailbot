require 'rss'

module Mailbot
  module Models
    class News < Job
      STEAM_RSS = 'http://store.steampowered.com/feeds/news.xml'.freeze

      def perform
        feed = nil

        open(STEAM_RSS) { |rss| feed = RSS::Parser.parse(rss, false) }

        latest = feed.items&.first

        return unless latest
        return unless latest.date.utc.to_i > details['last_message'].to_i

        feed.items.each do |item|
          break if item.date.utc.to_i <= details['last_message'].to_i

          discord.send_message(details['discord_channel_id'], formatted_message(item))

          Mailbot.logger.info("Sending news story #{item.link} to channel #{details['discord_channel_id']}")

          sleep(0.5) # don't flood
        end

        self.details['last_message'] = latest.date.utc.to_i
        self.last_run_at = Time.now.utc

        save!
      end

      private

      def discord
        @discord ||= Mailbot.instance.discord.bot
      end

      # @param [RSS::RDF::Item] item
      def formatted_message(item)
        "#{Sanitize.fragment(item.content_encoded)} - #{item.link}"
      end
    end
  end
end
