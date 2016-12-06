require 'socket'

module Mailbot
  class Twitch
    attr_reader :socket, :thread

    def send(message)
      Mailbot.logger.info "< #{message}"
      socket.puts(message)
    end

    def send_string(string)
      send("PRIVMSG #open_mailbox :#{string}")
    end

    def stop
      Mailbot.logger.info 'Disconnecting from Twitch...'
      thread.exit
      socket.close
    end

    def start
      return if socket && !socket.closed?

      initialize_channel

      @thread = Thread.start do
        loop do
          ready = IO.select([socket])

          ready[0].each do |s|
            line = s.gets

            Mailbot.logger.info "> #{line}"

            command = parse(line)

            command.execute(self) if command
          end
        end
      end
    end

    def parse(input)
      match   = input.match(/^:(.+)!(.+) PRIVMSG #(.+) :(.+)$/)

      return unless match

      user    = User.find_or_initialize(match[1])
      message = match[4]

      Commands.from_input(user, message)
    end

    private

    def initialize_channel
      username = Mailbot.configuration.twitch.username

      Mailbot.logger.info "Preparing to connect to Twitch as #{username}..."

      @socket = TCPSocket.new('irc.chat.twitch.tv', 6667)

      socket.puts("PASS #{Mailbot.configuration.twitch.api_token}")
      socket.puts("NICK #{username}")
      socket.puts("JOIN ##{Mailbot.configuration.twitch.channel}")

      Mailbot.logger.info 'Connected...'
    end
  end
end
