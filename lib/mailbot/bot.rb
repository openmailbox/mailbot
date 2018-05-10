module Mailbot
  class Bot
    attr_reader :threads, :running, :twitch, :discord, :scheduler

    def initialize
      @running   = false
      @twitch    = Mailbot::Twitch.new
      @discord   = Mailbot::Discord.new
      @scheduler = Mailbot::Scheduler.new
      @threads   = []
    end

    def run
      @running = true

      if Mailbot.env == 'development'
        main_thread = Thread.start do
          while running do
            ARGV.clear

            print prompt

            command = gets.chomp

            if command == 'quit'
              @running = false
              scheduler.stop
              twitch.stop
              discord.stop
            elsif !command.empty?
              parser = Mailbot::Parser.new(command.downcase)
              puts parser.parse
            end
          end
        end

        threads << main_thread
      end

      scheduler.start if Mailbot.configuration.enable_scheduler
      twitch.start if Mailbot.configuration.enable_twitch
      discord.start if Mailbot.configuration.enable_discord

      threads << scheduler.thread
      threads << twitch.thread
      threads << discord.thread

      threads.each { |i| i&.join }

      Mailbot.logger.info 'Exited.'
    end

    def stop
      @running = false
      scheduler.stop
      twitch.stop
      discord.stop
    end

    private

    def prompt
      @prompt ||= "Mailbot(#{Mailbot.version}): > "
    end
  end
end
