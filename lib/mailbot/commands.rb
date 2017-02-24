require 'mailbot/commands/hello'
require 'mailbot/commands/roll'
require 'mailbot/commands/who'
require 'mailbot/commands/trivia'
require 'mailbot/commands/trivia/game'
require 'mailbot/commands/trivia/start'
require 'mailbot/commands/trivia/answer'

module Mailbot
  module Commands
    COMMANDS = {
      hello:  Commands::Hello,
      roll:   Commands::Roll,
      #who:    Commands::Who,
      trivia: Commands::Trivia
    }

    def self.from_input(user, message)
      command, *args = message.split
      command        = command[1..-1] # strip the !
      klass          = COMMANDS[command.to_sym]

      klass && klass.new(user, args)
    end
  end
end
