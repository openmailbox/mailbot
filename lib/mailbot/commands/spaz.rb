
module Mailbot
  module Commands
    class Spaz
      def initialize(user, args)
        @user = user
        @args = args
      end

      def execute(context)
        context.send_string("Are you fond of mustache styles popularized by cartoon villains? Then go check out my man SPAZEE_MCGEE! https://www.twitch.tv/spazee_mcgee")
      end
    end
  end
end
