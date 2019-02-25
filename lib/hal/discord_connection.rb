require 'discordrb'

module Hal
  class DiscordConnection
    RETRY_INTERVAL = 60 # seconds

    def initialize
      initialize_bot
    end

    # Are we actually connected to Discord?
    def connected?
      @bot.connected?
    end

    # Is the connection active? This can be true and #connected? false if
    # we're having trouble connecting to Discord.
    def running?
      @running
    end

    # Connects to Discord. Returns immediately. The caller is responsible for blocking if needed.
    def start
      Rails.logger.info 'Starting Discord bot.'

      @running = true

      @bot.run(true)

      # Allow other threads to signal this one to make sure we stay connected to Discord.
      @connection_thread = Thread.start do
        while running?
          break if !running?

          if running? && !connected?
            Rails.logger.info 'Attempting to reconnect Discord bot.'
            @bot.run(true)
          end

          Thread.stop
        end

        Rails.logger.info 'Disconnecting Discord bot.'
      end

      # Periodically signal the connection thread to make sure we reconnect if needed.
      @retry_thread = Thread.start do
        while running?
          @connection_thread.run
          sleep(RETRY_INTERVAL)
        end
      end
    end

    def stop
      @running = false

      @retry_thread.exit
      @connection_thread.run
      @connection_thread.join

      if @bot.connected?
        @bot.stop(true)
        @bot.join
      end
    end

    private

    def initialize_bot
      config = Rails.application.credentials.discord

      @bot = Discordrb::Commands::CommandBot.new(token: config[:token], client_id: config[:client_id], prefix: '!')

      @bot.disconnected do |event|
        Rails.logger.info "Disconnected from Discord due to #{event.inspect}"
      end
    end
  end
end
