require 'mailbot/commands/base'
require 'mailbot/commands/roll'
require 'mailbot/commands/swanson'
require 'mailbot/commands/trivia'
require 'mailbot/commands/trivia/game'
require 'mailbot/commands/trivia/start'
require 'mailbot/commands/trivia/answer'
#require 'mailbot/commands/zork'

module Mailbot
  module Commands
    COMMANDS = {
      roll:     Commands::Roll,
      swanson:  Commands::Swanson,
      trivia:   Commands::Trivia,
      #zork:     Commands::Zork,
    }

    def self.for_platform(name)
      Mailbot::Commands::Base.subclasses.select do |klass|
        klass.enabled_on?(name)
      end
    end
  end
end
