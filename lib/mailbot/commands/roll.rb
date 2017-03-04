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
          result = (1..match[1].to_i).inject(0) { |i| i += rand(match[2].to_i) + 1 }

          context.send_string("#{user.name} rolls #{match[0]} and gets #{result}!")
        end
      end
    end
  end
end
