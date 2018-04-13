module Mailbot
  module RSS
    class HumbleBundle < Feed
      RSS_URL = 'http://blog.humblebundle.com/rss'.freeze

      def refresh!
        feed = nil

        open(RSS_URL) { |rss| feed = ::RSS::Parser.parse(rss, false) }

        # TODO: Add category handling
        @items = feed.items.map do |item| # RSS::RDF::Item
          wrapper = Mailbot::RSS::FeedItem.new

          wrapper.guid         = item.link
          wrapper.title        = item.title
          wrapper.published_at = item.date
          wrapper.link         = item.link
          wrapper.description  = item.description

          wrapper
        end
      end
    end
  end
end
