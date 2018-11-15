module Mailbot
  module Models
    class RefreshNewsSubs < Job
      def perform
        last = last_run_at.to_i
        self.last_run_at = DateTime.now.utc

        api.news_feed_subscriptions(last).each do |data|
          feed = Mailbot::Models::NewsFeed.find_by(link: data.dig('news_feed', 'link'))

          next unless feed

          sub = feed.news_feed_subscriptions.find_or_initialize_by(guild_id: data['guild_id'])

          sub.discord_channel_id = data['discord_channel_id']
          sub.enabled = data['enabled']

          sub.save! if data['enabled'] && sub.changed?
          sub.destroy if !data['enabled'] && sub.persisted?
        end

        save!
      end

      private

      def api
        @api ||= Mailbot::WebClient.new
      end
    end
  end
end
