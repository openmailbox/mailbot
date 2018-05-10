require 'socket'

module Mailbot
  # The class that handles interaction with Twitch IRC-chat
  #
  # @attr_reader [Array<Mailbot::Models::ChannelMembership>] online currently connected chatters
  # @attr_reader [Twitch::Parser] parser the parser/tokenizer for Twitch chat
  # @attr_reader [TCPSocket] socket the socket connected to Twitch's chat server
  # @attr_reader [Thread] thread the background thread for processing chat incoming from the server
  class Twitch
    attr_reader :online, :parser, :socket, :thread

    def initialize
      @online = []
      @parser = Twitch::Parser.new(self)
    end

    # @param [Mailbot::Models::ChannelMembership] membership the user and channel who disconnected
    #
    # @return [Mailbot::Models::ChannelMembership, nil] the membership that was removed or nil
    def disconnect(membership)
      online.delete_if { |i| i == membership }
    end

    # @param [Mailbot::Models::User] user the user who sent the message
    # @param [Mailbot::Models::Channel] channel the channel the message originated from
    #
    # @return [Mailbot::Models::ChannelMembership] the membership for this user on this channel
    def find_or_create_membership(user, channel)
      member = online.find do |membership|
        membership.user == user && membership.channel == channel
      end

      unless member
        member = channel.channel_memberships.find_or_create_by(user: user)
        online << member
      end

      member
    end

    # @return [nil]
    def send(message)
      Mailbot.logger.info "< #{message}"
      socket.puts(message)
    end

    def send_string(channel_name, message)
      send("PRIVMSG ##{channel_name} :#{message}")
    end

    def stop
      return unless thread

      Mailbot.logger.info 'Disconnecting from Twitch...'
      socket.close
      Mailbot.logger.info 'Disconnected from Twitch.'
      thread.exit
    end

    def start
      return if socket && !socket.closed?

      initialize_channels

      @thread = Thread.start do
        loop do
          ready = IO.select([socket])

          ready[0].each do |s|
            line = s.gets

            raise Exception.new("EOF in stream: #{line.inspect}") if line.nil?

            Mailbot.logger.info "> #{line}"

            context = parser.parse(line)
            command = context.command

            command && command.execute(context)
          end
        end
      end
    rescue Errno::ETIMEDOUT => e
      Mailbot.logger.warn "Timeout error. Restarting: #{e}"
      @socket = nil
      retry
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

    def pong
      send("PONG #{Mailbot.configuration.twitch.username}")
      nil
    end
  end
end
