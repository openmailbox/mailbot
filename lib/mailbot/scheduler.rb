module Mailbot
  class Scheduler
    attr_reader :thread

    def start
      Mailbot.logger.info 'Starting scheduler...'

      @thread = Thread.start do
        loop do
          sleep(300)
        end
      end
    end

    def stop
      Mailbot.logger.info 'Stopping scheduler...'
      thread.exit
      Mailbot.logger.info 'Scheduler stopped.'
    end
  end
end
