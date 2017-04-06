module Mailbot
  class Bot
    attr_reader :threads, :running, :twitch, :scheduler

    def initialize
      @running   = false
      @twitch    = Mailbot::Twitch.new
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
            elsif !command.empty?
              twitch.send(command)
            end
          end
        end

        threads << main_thread
      end

      scheduler.start
      twitch.start

      threads << scheduler.thread
      threads << twitch.thread

      threads.each(&:join)
    end

    def stop
      @running = false
      scheduler.stop
      twitch.stop
    end

    private

    def prompt
      @prompt ||= "Mailbot(#{Mailbot.version}): > "
    end
  end
end
