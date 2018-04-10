module Mailbot
  module RSS
    class Newegg < Feed
      RSS_URL  = 'https://www.newegg.com/Product/RSS.aspx?Submit=RSSDailyDeals&Depa=0'.freeze
      KEYWORDS = ['Graphics Card', 'Desktop Processor', 'Solid State Drive', 'Hard Disk Drive']

      # TODO: discord.bot.send_message(channel.id, 'testing', false, image: Discordrb::Webhooks::EmbedImage.new(url: 'https://www.ruby-lang.org/images/header-ruby-logo.png'))
      def refresh!
        feed = nil

        open(RSS_URL) { |rss| feed = ::RSS::Parser.parse(rss, false) }

        @items = feed.items.map do |item| # RSS::Rss::Channel::Item
          wrapper = Mailbot::RSS::FeedItem.new

          wrapper.guid         = item.guid.content
          wrapper.title        = item.title
          wrapper.published_at = item.date
          wrapper.link         = item.link
          wrapper.description  = item.title # TODO: Parse the HTML-formatted desc

          wrapper
        end
      end
    end
  end
end
