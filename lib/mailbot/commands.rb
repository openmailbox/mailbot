require 'mailbot/commands/base'
require 'mailbot/commands/roll'
require 'mailbot/commands/swanson'
require 'mailbot/commands/rust'
require 'mailbot/commands/rust/status'
require 'mailbot/commands/trivia'
require 'mailbot/commands/trivia/game'
require 'mailbot/commands/trivia/start'
require 'mailbot/commands/trivia/answer'

module Mailbot
  module Commands
    def self.for_platform(name)
      Mailbot::Commands::Base.subclasses.select do |klass|
        klass.enabled_on?(name)
      end
    end
  end
end
