module Mailbot
  module Commands
    class Hello
      attr_reader :user

      def initialize(user)
        @user = user
      end

      def execute(context)
        Mailbot.logger.info "USER COMMAND: #{user} - !hello"
        context.send_string("Hello, #{user} from Mailbot!")
      end
    end
  end
end
