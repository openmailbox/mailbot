module Mailbot
  class Bot
    attr_reader :threads, :running, :twitch, :discord, :scheduler

    def initialize
      @running   = false
      @twitch    = Mailbot::Twitch.new
      @discord   = Mailbot::Discord.new
      @scheduler = Mailbot::Scheduling::Scheduler.new
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
              twitch.send(command)
            end
          end
        end

        threads << main_thread
      end

      scheduler.start
      twitch.start
      discord.start

      threads << scheduler.thread
      threads << twitch.thread
      threads << discord.thread

      # Test job
      #job = Mailbot::Scheduling::Job.new(60) do 
      #  Mailbot.logger.info("Sending message...")
      #  Mailbot.instance.twitch.send_string(Mailbot::Scheduling::Job::TWITCH_CHANNEL, "Test job w/ 60 sec interval!")
      #end

      #scheduler.add(job)

      threads.each(&:join)

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
