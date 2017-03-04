module Mailbot
  module Commands
    class Roll
      attr_reader :user, :args

      # @param [User] user The instance of a user
      # @param [Array<String>] args
      def initialize(user, args)
        @user = user
        @args = args
      end

      def execute(context)
        Mailbot.logger.info "USER COMMAND: #{user.name} - !roll"

        result = ((Random.rand * 19) + 1).round

        context.send_string("#{user.name} rolled 1d20 and got #{result}!")
      end
    end
  end
end
