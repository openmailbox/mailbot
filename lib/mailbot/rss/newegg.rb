module Mailbot
  module RSS
    class Newegg < Feed
      RSS_URL  = 'https://www.newegg.com/Product/RSS.aspx?Submit=RSSDailyDeals&Depa=0'.freeze
      ICON_URL = 'https://pbs.twimg.com/profile_images/265989396/shell_shocker.png'.freeze
      COLOR    = 16743680 # orange

      # @override
      def discord_embed(item)
        embed = Discordrb::Webhooks::Embed.new
        html  = Nokogiri::HTML(item.description)
        price = html.css('div')[3]&.content&.split&.last

        embed.title     = item.title
        embed.url       = item.link
        embed.color     = COLOR
        embed.footer    = Discordrb::Webhooks::EmbedFooter.new(text: 'Newegg', icon_url: ICON_URL)
        embed.image     = Discordrb::Webhooks::EmbedImage.new(url: "https:#{html.css('img').first.attributes['src'].value}")
        embed.timestamp = item.published_at

        html.css('div')[1..-2].each do |div|
          embed.add_field(field_values(div))
        end

        embed.add_field(name: 'Buy Now', value: cart_url(html), inline: true)

        embed
      end

      # @override
      def format_message(item)
        "#{Sanitize.fragment(item.title)} - #{item.link}"
      end

      def refresh!
        feed = nil

        open(RSS_URL) { |rss| feed = ::RSS::Parser.parse(rss, false) }

        @items = feed.items.map do |item| # RSS::Rss::Channel::Item
          wrapper = Mailbot::RSS::FeedItem.new

          wrapper.guid         = item.guid.content
          wrapper.title        = item.title
          wrapper.published_at = item.date
          wrapper.link         = item.link
          wrapper.description  = item.description

          wrapper
        end
      end

      private

      def cart_url(html)
        "[Add To Cart](#{html.css('div a').first.attributes['href'].value})"
      end

      # @param [Nokogiri::XML::Element] div The div to parse
      def field_values(div)
        name  = div.css('strong')&.first&.content&.strip&.chomp(':')
        value = div.children.last.content.strip

        if name.blank?
          name  = value.split.first
          value = value.split[1..-1].join(' ')
        end

        {
          name: name,
          value: value,
          inline: true
        }
      end
    end
  end
end
