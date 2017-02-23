module Mailbot
  module Commands
    class Trivia
      class Game
        BASE_URL = 'https://www.opentdb.com/api.php'

        @@game = nil

        attr_reader :answers,
                    :current_choices, 
                    :questions,
                    :round, 
                    :round_started_at, 
                    :scores

        def self.current
          @@game
        end

        def initialize
          @@game     = self
          @round     = 0
          @scores    = {}
          @questions = fetch_questions
        end

        def advance
          winners.each do |user|
            scores[user] ||= 0
            scores[user] += 1
          end

          @answers          = {}
          @round_started_at = Time.now.to_i

          @round += 1

          initialize_choices
        end

        def answer(user, choice)
          answers[choice - 1] ||= []
          answers[choice - 1] << user
        end

        def current_correct_index
          decoder = HTMLEntities.new

          current_choices.index do |answer|
            answer == decoder.decode(current_question['correct_answer'])
          end
        end

        def current_question
          questions[round - 1]
        end

        def game_over
          @@game = nil
        end

        def leaderboard
          scores.sort_by { |user, score| score }.reverse.map(&:first)[0..2]
        end

        def winners
          if round > 0
            answers[current_correct_index] || []
          else
            []
          end
        end

        private

        def fetch_questions
          response = HTTParty.get(BASE_URL + '?amount=10')

          JSON.parse(response.body)['results']
        end

        def initialize_choices
          @current_choices = current_question['incorrect_answers'] << current_question['correct_answer']
          coder            = HTMLEntities.new

          @current_choices = current_choices.map do |choice|
            coder.decode(choice)
          end

          current_choices.shuffle!
        end
      end
    end
  end
end
