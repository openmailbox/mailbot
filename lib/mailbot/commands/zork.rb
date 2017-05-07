module Mailbot
  module Commands
    class Zork
      attr_reader :user, :args

      def initialize(user, args)
        @user = user
        @args = args
      end

      def execute(context)
        if args.length > 0
          command_buffer.write(args.join(' ') + "\n")
          command_buffer.flush
        else
          msg = "Twitch Plays Zork is active!"
          msg << " Use !zork <command> to send a command to the game."
          msg << " What's zork? Read https://en.wikipedia.org/wiki/Zork"

          context.send_string(msg)
        end
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
