module Mailbot
  module Commands
    class Discord
      def initialize(user, args)
        @user = user
        @args = args
      end

      def execute(context)
        context.send_string("Join the Great Underground Empire on Discord! https://discord.gg/dzgnAns")
      end
    end
  end
end
