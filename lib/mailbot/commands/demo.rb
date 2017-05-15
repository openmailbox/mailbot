module Mailbot
  module Commands
    class Demo
      def initialize(user, args)
        @user = user
        @args = args
      end

      def execute(context)
        context.send_string("I make games live on Mondays and Fridays! You can download a demo for one here: www.open-mailbox.com/games/kesselrunner")
      end
    end
  end
end
