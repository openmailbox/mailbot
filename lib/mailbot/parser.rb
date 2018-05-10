module Mailbot
  class Parser
    attr_reader :input, :intent, :action

    @@actions = {}

    def self.register_action(intent, &block)
      @@actions[intent] = block
    end

    def initialize(input)
      @input = input
    end

    def parse
      @intent = parser.parse(input)
      @action = @@actions[intent.first.to_sym]

      @action&.call(intent.last)
    end

    private

    # TODO: Move this into class-level initialization
    def parser
      return @parser if @parser

      @parser = UtteranceParser.new
      @parser.train(Hash[CSV.read(Mailbot.root + '/config/parser_training.csv')])
      @parser
    end
  end
end

Mailbot::Parser.register_action(:time) do |hash|
  "The current time is #{DateTime.now.to_s}."
end

Mailbot::Parser.register_action(:greeting) do
  "Hello there."
end
