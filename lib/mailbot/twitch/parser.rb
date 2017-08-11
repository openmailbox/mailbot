module Mailbot
  class Twitch
    private

    class Parser
      attr_reader :twitch

      # @param [Mailbot::Twitch] twitch the instance of the Twitch object
      def initialize(twitch)
        @twitch = twitch
      end

      # @param [String] line the line of text returned from the socket to IRC-chat
      #
      # @return [Context] a contextual object with the parsed/tokenized chat data
      def parse(line)
        context = Context.new

        if line =~ /^PING/
          pong
          return context
        end

        tokens = line && tokenize(line)

        return context unless tokens

        context.user    = Mailbot::Models::User.find_or_create_by(name: tokens[:user])
        context.service = Mailbot::Models::Channel.find_by(name: tokens[:channel])
        membership      = twitch.find_or_create_membership(context.user, context.service)

        case tokens[:action]
        when 'PART'
          twitch.disconnect(membership)
        when 'PRIVMSG'
          membership.last_message_at = DateTime.now
          membership.save

          context.command = get_command(context.user, tokens[:message])
        end

        context
      end

      private

      def get_command(user, message)
        return unless message.to_s[0] == '!'

        command, *args = message.split
        command        = command[1..-1] # strip the !

        klass = Mailbot::Commands.for_platform(:twitch).find do |command_klass|
          command_klass.command_name == command
        end

        klass && klass.new(user, args)
      end

      def pong
        twitch.send("PONG #{Mailbot.configuration.twitch.username}")
        nil
      end

      def tokenize(line)
        match = line.match(/^:(.+)!(.+) (JOIN|PART|PRIVMSG) #(.+)$/)

        return unless match

        channel_name, *message = match[4].split

        tokens           = {}
        tokens[:user]    = match[1]
        tokens[:action]  = match[3]
        tokens[:channel] = channel_name
        tokens[:message] = message.any? && message.join(' ').sub(/^:/, '')

        tokens
      end
    end
  end
end
