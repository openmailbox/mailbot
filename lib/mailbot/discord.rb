require 'discordrb'

module Mailbot
  class Discord
    attr_reader :bot

    def initialize
      config = Mailbot.configuration.discord
      @bot = Discordrb::Commands::CommandBot.new(token: config.token, client_id: config.client_id, prefix: '!')

      bot.command(:roll) do |event, value|
        user = Mailbot::Models::User.new(name: event.author.username)
        Commands::Roll.new(user, Array(value)).execute(self)
      end
    end

    # Makes this quack like Twitch::Context so the command handling is the same
    def send_string(message)
      message
    end

    def start
      bot.run(:async)
    end

    def stop
      Mailbot.logger.info 'Disconnecting from Discord...'
      bot.stop
      bot.sync
      Mailbot.logger.info 'Disconnected from Discord.'
    end
  end
end
