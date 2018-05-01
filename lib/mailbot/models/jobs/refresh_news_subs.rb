module Mailbot
  module Models
    class RefreshNewsSubs < Job
      URL = 'http://localhost:3000/news_feed_subscriptions.json'.freeze

      def perform
        fetch_subs

        self.last_run_at = DateTime.now.utc

        save!
      end

      def headers
        {
          'X-MAILBOT-API-TOKEN' => 'abc123'
        }
      end

      def fetch_subs
        JSON.parse(HTTParty.get("#{URL}?since=#{last_run_at.to_i}", headers: headers).body)
      end
    end
  end
end
