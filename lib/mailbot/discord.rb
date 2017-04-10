require 'discordrb'

module Mailbot
  class Discord
    attr_reader :bot

    def initialize
      config = Mailbot.configuration.discord
      @bot = Discordrb::Commands::CommandBot.new(token: config.token, client_id: config.client_id, prefix: '!')

      bot.command(:hello) do |event, name|
        "Hello to #{name}!"
      end
    end

    def start
      bot.run(:async)
    end

    def stop
      bot.stop
    end
  end
end
