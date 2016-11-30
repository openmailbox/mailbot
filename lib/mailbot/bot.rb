module Mailbot
  class Bot
    attr_reader :main_thread, :running, :twitch

    def initialize
      @running = false
      @twitch  = Mailbot::Twitch.new
    end

    def run
      twitch.start

      @running = true

      @main_thread = Thread.start do
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

      threads.each(&:join)
    end

    private

    def prompt
      @prompt ||= "Mailbot(#{Mailbot.version}): > "
    end

    def threads
      [twitch.thread, main_thread]
    end
  end
end
