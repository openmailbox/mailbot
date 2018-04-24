module Mailbot
  module RSS
    class Steam < Feed
      RSS_URL = 'http://store.steampowered.com/feeds/news.xml'.freeze

      def refresh!
        feed = nil

        open(RSS_URL) { |rss| feed = ::RSS::Parser.parse(rss, false) }

        @items = feed.items.map do |item| # RSS::RDF::Item
          wrapper = Mailbot::RSS::FeedItem.new

          wrapper.guid         = guid_from_link(item.link)
          wrapper.title        = item.title
          wrapper.published_at = item.date
          wrapper.link         = item.link
          wrapper.description  = item.content_encoded

          wrapper
        end
      end

      private

      # The steam link sometimes comes back as https or http causing dupes.
      #
      # @return [String] A link formatted for guid usage.
      def guid_from_link(link)
        protocol, path = link.split('//').last
      end
    end
  end
end
