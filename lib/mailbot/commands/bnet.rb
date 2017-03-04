module Mailbot
  module Commands
    class Bnet
      BNET_USERNAME = 'openmailbox#1399'

      def initialize(user, args)
        @user = user
        @args = args
      end

      def execute(context)
        context.send_string("Add me on Battle.net! #{BNET_USERNAME}")
      end
    end
  end
end
