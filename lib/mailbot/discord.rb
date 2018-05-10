require 'discordrb'

module Mailbot
  class Discord
    attr_reader :bot, :thread

    def initialize
      initialize_bot
      initialize_commands
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
      return unless thread

      Mailbot.logger.info 'Disconnecting from Discord...'
      no_sync = Mailbot.env == 'production' ? true : false
      bot.stop(no_sync)
      bot.sync
      Mailbot.logger.info 'Disconnected from Discord.'
      thread.exit
    end

    private

    def initialize_bot
      config = Mailbot.configuration.discord

      @bot = Discordrb::Commands::CommandBot.new(token:     config.token,
                                                 client_id: config.client_id,
                                                 prefix:    '!')

      bot.disconnected do |event|
        Mailbot.logger.info("Disconnected from Discord due to #{event.inspect}")
      end
    end

    def initialize_commands
      Mailbot::Commands.for_platform(:discord).each do |command_klass|
        register_command(command_klass)
      end
    end

    def initialize_context(event)
      context = Context.new

      # TODO: Persist the user. Probably need to adjust the model.
      context.user    = Mailbot::Models::User.new(name: event.author.username)
      context.service = event.server && Mailbot::Models::Community.find_or_create_by(name: event.server.id)
      context.event   = event

      context
    end

    def register_command(command_klass)
      bot.command(command_klass.command_name.to_sym) do |event, *args|
        context = initialize_context(event)

        result = command_klass.new(context.user, args).execute(context)

        context.service.nil? ? result : nil
      end
    end
  end
end
