require 'socket'
require 'logger'

module Mailbot
  class Twitch < Channel
    attr_reader :socket

    def initialize(*args)
      super
      @socket = nil
    end

    def send(message)
      logger.info "< #{message}"
      socket.puts(message)
    end

    private

    def initialize_channel
      username = Mailbot.config.settings['twitch']['username']

      logger.info "Preparing to connect to Twitch as #{username}..."

      @socket = TCPSocket.new('irc.chat.twitch.tv', 6667)

      socket.puts("PASS #{ENV['TWITCH_CHAT_TOKEN']}")
      socket.puts("NICK #{username}")

      logger.info 'Connected...'
    end

    # Single iteration of the loop
    # override
    def run
      ready = IO.select([socket])

      ready[0].each do |s|
        line    = s.gets
        match   = line.match(/^:(.+)!(.+) PRIVMSG #(.+) :(.+)$/)
        message = match && match[4]

        if message =~ /^!hello/
          user = match[1]
          logger.info "USER COMMAND: #{user} - !hello"
          send "PRIVMSG #open_mailbox :Hello, #{user} from Mailbot!"
        end

        logger.info "> #{line}"
      end
    end

  end
end
