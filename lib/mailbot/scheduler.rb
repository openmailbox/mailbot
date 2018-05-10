module Mailbot
  class Scheduler
    attr_reader :thread

    def start
      Mailbot.logger.info 'Starting scheduler...'

      @thread = Thread.start do
        loop do
          Mailbot.logger.info("Running jobs...")

          Mailbot::Models::Job.find_each do |job|
            next unless job.ready?

            Mailbot.logger.info("Running #{job.inspect}")
            job.perform
            Mailbot.logger.info("Done with #{job.inspect}")
          end

          Mailbot.logger.info("Done running jobs...")

          sleep(300)
        end
      end
    end

    def stop
      return unless thread

      Mailbot.logger.info 'Stopping scheduler...'
      thread.exit
      Mailbot.logger.info 'Scheduler stopped.'
    end
  end
end
