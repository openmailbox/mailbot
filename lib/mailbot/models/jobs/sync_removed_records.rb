module Mailbot
  module Models
    class SyncRemovedRecords < Job
      def perform
        last = last_run_at.to_i
        self.last_run_at = DateTime.now.utc

        api.removed_records(last).each do |data|
          case data['model_type']
          when 'LurkList'
            LurkList.find_by(mailbot_rails_id: data['model_id'])&.destroy
          else
            Mailbot.logger.warn("Unrecognized RemovedRecord type: #{data['model_type']}")
          end
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
