module Mailbot
  module Commands
    class Trivia
      class Start
        attr_reader :trivia

        def initialize(trivia)
          @trivia = trivia
        end

        def execute
          return 'There is already a game in progress!' if current_game

          context.send_string("Starting a new trivia game!")

          start_game

          nil
        end

        private

        def context
          trivia.context
        end

        def current_game
          Trivia::Game.from_context(context)
        end

        def start_game
          Trivia::Game.new(context)
          current_game.advance
          trivia.ask_question
          trivia.start_round
        end
      end
    end
  end
end
