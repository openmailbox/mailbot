module Mailbot
  module Commands
    class Who
      attr_reader :user

      # @param [User] user The instance of a user
      def initialize(user)
        @user = user
      end

      def execute(context)
        name_list = User.list.map(&:name)

        context.send_string("Users the bot knows about: #{name_list.join(', ')}")
      end
    end
  end
end
