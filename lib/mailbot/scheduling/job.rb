module Mailbot
  module Scheduling
    class Job
      TWITCH_CHANNEL = 'open_mailbox'

      attr_reader :frequency, :block, :last_run

      def initialize(frequency, &block)
        @frequency = frequency
        @block     = block
        @last_run  = 0
      end

      def perform
        block.call
        @last_run = Time.now.to_i
      end

      def ready?
        Time.now.to_i >= (last_run + frequency)
      end
    end
  end
end