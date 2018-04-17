module Mailbot
  module Models
    # Update all instances of NewsFeed
    class UpdateNewsFeeds < Job
      def perform
        self.last_run_at = DateTime.now.utc

        Mailbot::Models::NewsFeed.find_each do |feed|
          feed.refresh_and_notify!
        end

        save!
      end
    end
  end
end
