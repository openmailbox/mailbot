require 'socket'
require 'logger'

Thread.abort_on_exception = true

class Twitch
  attr_reader :logger, :running, :socket

  def initialize(logger = nil)
    @logger  = logger || Logger.new(STDOUT)
    @running = false
    @socket  = nil
  end

  def send(message)
    logger.info "< #{message}"
    socket.puts(message)
  end

  def run
    logger.info 'Preparing to connect...'

    @socket = TCPSocket.new('irc.chat.twitch.tv', 6667)
    @running = true

    socket.puts("PASS #{ENV['TWITCH_CHAT_TOKEN']}")
    socket.puts("NICK open_mailbox")

    logger.info 'Connected...'

    # :rerespek!rerespek@rerespek.tmi.twitch.tv PRIVMSG #open_mailbox :so ez :) thanks for the lesson

    Thread.start do
      while (running) do
        ready = IO.select([socket])

        ready[0].each do |s|
          line    = s.gets
          match   = line.match(/PRIVMSG #(.+) :(.+)$/)
          message = match && match[2]

          if message =~ /^!hello/
            logger.info "COMMAND RECEIVED"
            send "PRIVMSG #open_mailbox :Hello, World from the bot!"
          else
            logger.info message.inspect
          end

          logger.info "> #{line}"
        end
      end
    end
  end

  def stop
    @running = false
  end
end

bot = Twitch.new
bot.run

while (bot.running) do
  command = gets.chomp

  if command == 'quit'
    bot.stop
  else
    bot.send(command)
  end
end

puts 'Exited.'
