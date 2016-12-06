require 'mailbot/commands/hello'

module Mailbot
  module Commands
    COMMANDS = {
      hello: Commands::Hello
    }

    def self.from_input(user, message)
      typed_command = message.split.first[1..-1]
      COMMANDS[typed_command.to_sym].new(user)
    end
  end
end
