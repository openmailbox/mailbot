module Mailbot
  module Commands
    class Zork
      def initialize(user, args)
        @user = user
        @args = args
      end

      def execute(context)
        command_buffer.write(args.join(' ') + "\n")
        command_buffer.flush
      end

      private

      def command_buffer
        if @command_buffer && !@command_buffer.closed?
          @command_buffer
        else
          @command_buffer = File.open(Mailbot.root + '/zork.txt', 'a')
        end
      end
    end
  end
end
