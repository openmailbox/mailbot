module Mailbot
  module RSS
    class Steam < Feed
      RSS_URL = 'http://store.steampowered.com/feeds/news.xml'.freeze

      def refresh!
        feed = nil

        open(RSS_URL) { |rss| feed = ::RSS::Parser.parse(rss, false) }

        @items = feed.items.map do |item| # RSS::RDF::Item
          wrapper = Mailbot::RSS::FeedItem.new

          wrapper.title        = item.title
          wrapper.published_at = item.date
          wrapper.link         = item.link
          wrapper.description  = item.content_encoded

          wrapper
        end
      end
    end
  end
end
