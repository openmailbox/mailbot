module Mailbot
  module Commands
    class Hello
      attr_reader :user, :args

      # @param [User] user The instance of user
      def initialize(user, args)
        @user = user
        @args = args
      end

      def execute(context)
        Mailbot.logger.info "USER COMMAND: #{user.name} - !hello"
        context.send_string("Hello, #{user.name} from Mailbot!")
      end
    end
  end
end
