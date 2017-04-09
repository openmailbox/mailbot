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
      # @return [Twitch::Context] a contextual object with the parsed/tokenized chat data
      def parse(line)
        return pong if line =~ /^PING/

        context = Twitch::Context.new
        tokens  = line && tokenize(line)

        return context unless tokens

        context.user    = Mailbot::Models::User.find_or_create_by(name: tokens[:user])
        context.channel = Mailbot::Models::Channel.find_by(name: tokens[:channel])
        membership      = twitch.find_or_create_membership(context.user, context.channel)

        case tokens[:action]
        when 'PART'
          twitch.disconnect(membership)
        when 'PRIVMSG'
          membership.last_message_at = DateTime.now
          membership.save

          context.command = Mailbot::Commands.from_input(context.user, tokens[:message])
        end

        context
      end

      private

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
