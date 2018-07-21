module Mailbot
  module Models
    class RefreshLurkLists < Job
      def perform
        self.last_run_at = Time.now.utc
        save!
      end
    end
  end
end
