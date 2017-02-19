require 'json'

module Mailbot
  module Commands
    class Trivia
      BASE_URL = 'https://www.opentdb.com/api.php'

      class Game
        def self.current
          @@game
        end

        def initialize
          @@game     = self
          @round     = 1
          @questions = fetch_questions
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
