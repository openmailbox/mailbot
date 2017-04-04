module Mailbot
  module Commands
    class Giveaway
      URL    = 'https://gleam.io/QDqqV/open-your-mailbox-for-a-fallout-4-mystery-mini'
      ENDING = Time.new(2017, 4, 11, 23, 59, 59, '-04:00')

      def initialize(user, args)
        @user = user
        @args = args
      end

      def execute(context)
        if over?
          context.send_string('There is no current giveaway in progress. Sorry!')
        else
          context.send_string("Enter for your chance to win a cute Fallout 4 vinyl mini! #{URL}")
        end
      end

      private

      def over?
        Time.now.getlocal('-04:00') > ENDING
      end
    end
  end
end
