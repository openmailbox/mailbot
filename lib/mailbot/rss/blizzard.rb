module Mailbot
  module RSS
    class Blizzard < Feed
      SITE_URL = 'https://news.blizzard.com/en-us'

      def refresh!
        html = Nokogiri::HTML(open(SITE_URL))

        @items = html.css('.ArticleListItem').map do |div|
          wrapper = Mailbot::RSS::FeedItem.new

          wrapper.guid  = div.css('a').first.attributes['href'].value
          wrapper.title = div.css('h3').first.content
          wrapper.link  = wrapper.guid

          timestamp_text = div.css('.ArticleListItem-footerTimestamp').first.content

          wrapper.published_at = Chronic.parse(timestamp_text).beginning_of_hour
          wrapper.description  = div.css('.h6').first.content.strip

          wrapper
        end
      end
    end
  end
end
