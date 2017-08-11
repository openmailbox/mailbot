require 'mailbot/commands/base'
require 'mailbot/commands/roll'
require 'mailbot/commands/swanson'
require 'mailbot/commands/trivia'
require 'mailbot/commands/trivia/game'
require 'mailbot/commands/trivia/start'
require 'mailbot/commands/trivia/answer'
require 'mailbot/commands/zork'

module Mailbot
  module Commands
    COMMANDS = {
      roll:     Commands::Roll,
      swanson:  Commands::Swanson,
      trivia:   Commands::Trivia,
      #zork:     Commands::Zork,
    }

    def self.from_input(user, message)
      return unless message.to_s[0] == '!'

      command, *args = message.split
      command        = command[1..-1] # strip the !
      klass          = COMMANDS[command.to_sym]

      klass && klass.new(user, args)
    end
  end
end
