module Mailbot
  module Commands
    class Review
      def initialize(user, args)
        @user = user
        @args = args
      end

      def execute(context)
        Mailbot.logger.info "USER COMMAND: #{user.name} - !review #{args}"

        if args.length == 2
        elsif args.length == 1
        else
          message =  "Add a community game review with '!review <game> <1-5>'. "
          message << "See the community average for a game with '!review <game>'."

          context.send_string(message)
        end
      end
    end
  end
end
