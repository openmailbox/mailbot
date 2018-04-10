module Mailbot
  module RSS
    FeedItem = Struct.new(:title, :link, :guid, :published_at, :description)

    class Feed
      KEYWORDS = []

      attr_reader :items

      def initialize
        @items = []
      end

      # @param [Mailbot::RSS::FeedItem] item The item to format
      def format_message(item)
        "#{Sanitize.fragment(item.description)} - #{item.link}"
      end

      def refresh!
        raise NotImplementedError.new('Subclasses must override #refresh!')
      end

      def keywords
        self.class::KEYWORDS
      end
    end
  end
end
