module Mailbot
  module Models
    class Job < ActiveRecord::Base
      serialize :details, JSON

      def perform
        raise NotImplementedError.new('Subclasses must implement #perform')
      end

      def ready?
        Time.now.to_i >= (last_run_at.to_i + frequency)
      end
    end
  end
end
