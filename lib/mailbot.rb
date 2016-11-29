Thread.abort_on_exception = true

module Mailbot
  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield configuration
  end

  def self.root
    @root ||= File.expand_path('../../', __FILE__)
  end

  def self.start
    channel = Mailbot::Twitch.new
    channel.listen

    while (channel.running) do
      command = gets.chomp

      if command == 'quit'
        channel.stop
      else
        channel.send(command)
      end
    end
  end
end

require 'mailbot/configuration'
require 'mailbot/twitch'
