require 'json'

module Mailbot
  module Commands
    class Trivia
      class Game
        BASE_URL = 'https://www.opentdb.com/api.php'

        attr_reader :questions

        def self.current
          @@game
        end

        def initialize
          @@game     = self
          @round     = 1
          @questions = fetch_questions
        end

        def current_question
          questions[round - 1]
        end

        def advance
          @round += 1
        end

        private

        def fetch_questions
          response = HTTParty.get(BASE_URL + '?amount=10')

          JSON.parse(response.body)['results']
        end
      end
    end
  end
end
