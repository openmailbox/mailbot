module Mailbot
  module RSS
    FeedItem = Struct.new(:title, :link, :guid, :published_at, :description)

    class Feed
      attr_reader :items

      def initialize
        @items = []
      end

      # @param [DateTime] time Only return items after this time
      #
      # @return [Array<Mailbot::RSS::FeedItem>] The matching items
      def items_since(time)
        filtered = items.select do |item|
          item.published_at.utc >= time.utc
        end

        filtered.sort { |i| i.published_at }.reverse # newest first
      end

      def refresh!
        raise NotImplementedError.new('Subclasses must override #refresh!')
      end
    end
  end
end
