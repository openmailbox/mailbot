module Mailbot
  # @abstract
  #
  # Abstract base class for services the bot knows how to interact with
  # i.e. Twitch, Discord
  #
  # @attr_reader [Thread] thread The background thread for processing communication via this connection
  class Connection
    attr_reader :thread

    def initialize
      raise NotImplementedError.new('Cannot instantiate abstract class.')
    end

    def start
      raise NotImplementedError.new('Subclasses must implement #start')
    end

    def stop
      raise NotImplementedError.new('Subclasses must implement #stop')
    end
  end
end
