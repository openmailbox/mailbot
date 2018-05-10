module Mailbot
  module NLP
    class Parser
      attr_reader :input, :intent, :arguments, :action

      def self.initialize_parser
        @@parser = UtteranceParser.new
        @@parser.train(Hash[CSV.read(Mailbot.root + '/config/parser_training.csv')])
        @@parser
      end

      def initialize(input)
        @input = input
      end

      # @return [Class, nil] The subclass of NLP::Action::Base or nil
      def parse
        Mailbot.logger.info("PARSING: #{input}")

        parsed     = parser.parse(input)
        @intent    = parsed.first.to_sym
        @arguments = parsed.last

        Mailbot::NLP.actions.find do |klass|
          klass.action_name == intent.to_s
        end
      end

      private

      def parser
        @@parser
      end
    end
  end
end
