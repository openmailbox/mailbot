module Mailbot
  class Bot
    attr_reader :threads, :running, :twitch, :discord, :scheduler

    def initialize
      @running   = false
      @twitch    = Mailbot::Twitch::Connection.new
      @discord   = Mailbot::Discord::Connection.new
      @scheduler = Mailbot::Scheduler.new
      @threads   = []

      Mailbot::NLP::Parser.initialize_parser
    end

    def run
      @running = true

      if Mailbot.env == 'development'
        main_thread = Thread.start do
          while running do
            ARGV.clear

            print prompt

            text = gets.chomp

            if text == 'quit'
              @running = false
              scheduler.stop
              twitch.stop
              discord.stop
            elsif !text.empty?
              context      = Context.new
              parser       = NLP::Parser.new(text)
              action_klass = parser.parse

              context.user    = Mailbot::Models::User.new(name: 'User')
              context.command = action_klass&.new(context.user, parser.arguments)

              puts context.command&.execute(context)
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
