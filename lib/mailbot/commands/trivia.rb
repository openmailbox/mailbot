module Mailbot
  module Commands
    class Trivia
      attr_reader :user, :args

      def initialize(user, args)
        @user = user
        @args = args
      end

      def execute(context)
        Mailbot.logger.info "USER COMMAND: #{user.name} - !trivia #{args}"

        if args.first.empty?
          if Trivia::Game.current.nil?
            context.send_string("There is no trivia game in progress.\n\tStart a new game with '!trivia start'.")
          else
          end
        elsif args.first == 'start'
          game = Trivia::Game.new
        end
      end
    end
  end
end
