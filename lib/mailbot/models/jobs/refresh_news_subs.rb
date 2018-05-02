module Mailbot
  module Models
    class RefreshNewsSubs < Job
      def perform
        self.last_run_at = DateTime.now.utc

        save!
      end
    end
  end
end
