module Mailbot
  module Commands
    class Roll
      attr_reader :user

      def initialize(user)
        @user = user
      end

      def execute(context)
        Mailbot.logger.info "USER COMMAND: #{user} - !roll"

        result = ((Random.rand * 19) + 1).round

        context.send_string("#{user} rolled 1d20 and got #{result}!")
      end
    end
  end
end
