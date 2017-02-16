module Mailbot
  class Bot
    attr_reader :threads, :running, :twitch

    def initialize
      @running = false
      @twitch  = Mailbot::Twitch.new
      @threads = []
    end

    def run
      @running = true

      if Mailbot.env == 'development'
        main_thread = Thread.start do
          while running do
            print prompt

            command = gets.chomp

            if command == 'quit'
              @running = false
              twitch.stop
            elsif !command.empty?
              twitch.send(command)
            end
          end
        end

        threads << main_thread
      end

      twitch.start

      threads << twitch.thread

      threads.each(&:join)
    end

    def stop
      @running = false
      twitch.stop
    end

    private

    def prompt
      @prompt ||= "Mailbot(#{Mailbot.version}): > "
    end
  end
end
