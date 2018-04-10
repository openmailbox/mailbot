module Mailbot
  module RSS
    FeedItem = Struct.new(:title, :link, :guid, :published_at, :description)

    class Feed
      KEYWORDS = []

      attr_reader :items

      def initialize
        @items = []
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
