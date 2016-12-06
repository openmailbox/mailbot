require 'mailbot/commands/hello'
require 'mailbot/commands/roll'
require 'mailbot/commands/who'

module Mailbot
  module Commands
    COMMANDS = {
      hello: Commands::Hello,
      roll:  Commands::Roll,
      who:   Commands::Who
    }

    def self.from_input(user, message)
      typed_command = message.split.first[1..-1]
      klass         = COMMANDS[typed_command.to_sym]

      klass && klass.new(user)
    end
  end
end
