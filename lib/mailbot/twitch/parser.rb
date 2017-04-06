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
        context = Twitch::Context.new
        match   = line.match(/^:(.+)!(.+) (JOIN|PART|PRIVMSG) #(.+)$/)

        return context unless match

        user_name = match[1]

        channel_name, *message = match[4].split

        message    = message.join(' ').sub(/^:/, '')
        user       = match[1] && Mailbot::Models::User.find_or_create_by(name: match[1])
        channel    = channel_name && Mailbot::Models::Channel.find_by(name: channel_name)
        membership = twitch.find_or_create_membership(user, channel)
        command    = Mailbot::Commands.from_input(user, message)

        if match[3] == 'PART'
          twitch.disconnect(membership)
        elsif message.length > 0
          membership.last_message_at = DateTime.now
          membership.save
        end

        context.user    = user
        context.channel = channel
        context.command = command

        context
      end
    end
  end
end
