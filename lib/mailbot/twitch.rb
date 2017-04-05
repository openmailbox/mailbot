require 'socket'

module Mailbot
  class Twitch
    Context = Struct.new(:user, :channel, :command) do
      def send_string(message)
        channel.send_message(message)
      end
    end

    attr_reader :socket, :thread, :online

    def initialize
      @online = []
    end

    def send(message)
      Mailbot.logger.info "< #{message}"
      socket.puts(message)
    end

    def send_string(channel_name, message)
      send("PRIVMSG ##{channel_name} :#{message}")
    end

    def stop
      Mailbot.logger.info 'Disconnecting from Twitch...'
      thread.exit
      socket.close
    end

    def start
      return if socket && !socket.closed?

      initialize_channels

      @thread = Thread.start do
        loop do
          ready = IO.select([socket])

          ready[0].each do |s|
            line = s.gets

            Mailbot.logger.info "> #{line}"

            context = parse(line)
            command = context && context.command

            command.execute(context) if command
          end
        end
      end
    end

    def parse(input)
      return pong if input =~ /^PING/

      match = input.match(/^:(.+)!(.+) PRIVMSG #(.+) :(.+)$/)

      return unless match

      user       = Models::User.find_or_create_by(name: match[1])
      channel    = Models::Channel.find_by(name: match[3])
      membership = membership(user, channel)
      message    = match[4]
      command    = Commands.from_input(user, message)

      membership.last_message_at = DateTime.now
      membership.save

      Context.new(user, channel, command)
    end

    private

    def initialize_channels
      username = Mailbot.configuration.twitch.username

      Mailbot.logger.info "Preparing to connect to Twitch as #{username}..."

      @socket = TCPSocket.new('irc.chat.twitch.tv', 6667)

      socket.puts("PASS #{Mailbot.configuration.twitch.api_token}") # socket.puts hidden from log
      send("NICK #{username}")

      Models::Channel.all.each do |channel|
        send("JOIN ##{channel.name}")
      end

      send('CAP REQ :twitch.tv/membership')
    end

    def membership(user, channel)
      member = online.find do |membership|
        membership.user == user && membership.channel == channel
      end

      unless member
        member = channel.channel_memberships.find_or_initialize_by(user: user)
        online << member
      end

      member
    end

    def pong
      send("PONG #{Mailbot.configuration.twitch.username}")
      nil
    end
  end
end
