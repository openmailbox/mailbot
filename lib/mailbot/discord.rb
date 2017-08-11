require 'discordrb'

module Mailbot
  class Discord
    attr_reader :bot, :thread

    def initialize
      config = Mailbot.configuration.discord
      @bot   = Discordrb::Commands::CommandBot.new(token:     config.token,
                                                   client_id: config.client_id,
                                                   prefix:    '!')

      bot.command(:roll) do |event, value|
        context = initialize_context(event)
        Commands::Roll.new(context.user, Array(value)).execute(context)
      end

      bot.command(:trivia) do |event, command, answer|
        context = initialize_context(event)
        Commands::Trivia.new(context.user, [command, answer]).execute(context)
        nil
      end

      bot.disconnected do |event|
        Mailbot.logger.info("Disconnected from Discord due to #{event.inspect}")
      end
    end

    def start
      bot.run(:async)

      @thread = Thread.start do
        if !bot.connected?
          Mailbot.logger.info 'Attempting to reconnect to Discord.'
          bot.run(:async)
        end

        sleep(60)
      end
    end

    def stop
      Mailbot.logger.info 'Disconnecting from Discord...'
      no_sync = Mailbot.env == 'production' ? true : false
      bot.stop(no_sync)
      bot.sync
      Mailbot.logger.info 'Disconnected from Discord.'
      thread.exit
    end

    private

    def initialize_context(event)
      context = Context.new

      context.user    = Mailbot::Models::User.new(name: event.author.username)
      context.service = event.server && Mailbot::Models::Community.new(name: event.server.id)
      context.event   = event

      context
    end
  end
end
