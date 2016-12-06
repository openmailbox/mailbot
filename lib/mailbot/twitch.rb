require 'socket'
require 'logger'

module Mailbot
  class Twitch
    attr_reader :logger, :socket, :thread

    def initialize(logger = nil)
      @logger = logger || Logger.new(STDOUT)
    end

    def send(message)
      logger.info "< #{message}"
      socket.puts(message)
    end

    def stop
      logger.info 'Disconnecting from Twitch...'
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
            line    = s.gets
            match   = line.match(/^:(.+)!(.+) PRIVMSG #(.+) :(.+)$/)
            message = match && match[4]

            if message =~ /^!hello/
              user = match[1]
              logger.info "USER COMMAND: #{user} - !hello"
              send "PRIVMSG #open_mailbox :Hello, #{user} from Mailbot!"
            elsif message =~ /^!roll/
              user = match[1]
              logger.info "USER COMMAND: #{user} - !roll"
              result = ((Random.rand * 19) + 1).round
              send "PRIVMSG #open_mailbox :#{user} rolled 1d20 and got #{result}!"
            end

            logger.info "> #{line}"
          end
        end
      end
    end

    private

    def initialize_channel
      username = Mailbot.configuration.twitch_username

      logger.info "Preparing to connect to Twitch as #{username}..."

      @socket = TCPSocket.new('irc.chat.twitch.tv', 6667)

      socket.puts("PASS #{Mailbot.configuration.twitch_api_token}")
      socket.puts("NICK #{username}")

      logger.info 'Connected...'
    end
  end
end
