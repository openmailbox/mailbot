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
        Mailbot.logger.info "USER COMMAND: #{user.name} - !roll #{args}"

        match = args.any? && args.first.match(/^(\d+)d(\d+)$/)

        if !match
          context.send_string("Invalid roll command. Try '!roll 1d20' or '!roll 4d8'.")
        else
          d1 = match[1].to_i
          d2 = match[2].to_i

          if d1 > 100 || d2 > 100
            context.send_string("I'm sorry, Dave. I'm afraid I can't do that.")
          else
            result = (1..d1).inject(0) { |i| i += rand(d2) + 1 }

            context.send_string("#{user.name} rolls #{match[0]} and gets #{result}!")
          end
        end
      end
    end
  end
end
