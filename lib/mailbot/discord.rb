require 'discordrb'

module Mailbot
  class Discord
    attr_reader :bot

    def initialize
      config = Mailbot.configuration.discord
      @bot   = Discordrb::Commands::CommandBot.new(token:     config.token, 
                                                   client_id: config.client_id, 
                                                   prefix:    '!')

      bot.command(:roll) do |event, value|
        context = initialize_context(event)
        Commands::Roll.new(context.user, Array(value)).execute(context)
      end
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

    private

    def initialize_context(event)
      context = Context.new

      context.user    = Mailbot::Models::User.new(name: event.author.username)
      context.service = Mailbot::Models::Community.new(name: event.server.id)
      context.event   = event

      context
    end
  end
end
