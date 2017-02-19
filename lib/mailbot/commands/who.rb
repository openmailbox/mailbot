module Mailbot
  module Commands
    class Who
      attr_reader :user, :args

      # @param [User] user The instance of a user
      def initialize(user, args)
        @user = user
        @args = args
      end

      def execute(context)
        name_list = User.list.map(&:name)

        context.send_string("Users the bot knows about: #{name_list.join(', ')}")
      end
    end
  end
end
