module Mailbot
  module Commands
    class Steam
      STEAM_USERNAME = 'open_mailbox'

      def initialize(user, args)
        @user = user
        @args = args
      end

      def execute(context)
        context.send_string("Add me on Steam! http://steamcommunity.com/id/#{STEAM_USERNAME}")
      end
    end
  end
end
