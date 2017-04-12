module Mailbot
  module Commands
    class Trivia
      class Game
        Answer     = Struct.new(:user, :time, :choice)
        BASE_URL   = 'https://www.opentdb.com/api.php'
        MAX_POINTS = 50

        @@games = {}

        # @param [Mailbot::Context] context the context asking for some game
        def self.from_context(context)
          @@games[game_key(context)]
        end

        def self.game_key(context)
          type = context.service.class.to_s.split('::').last
          "#{type}-#{context.service.name}"
        end

        def self.games
          @@games
        end

        attr_reader :answers,
                    :current_choices,
                    :questions,
                    :round,
                    :round_started_at,
                    :scores,
                    :key

        # @param [Mailbot::Context] context the context of this command
        def initialize(context)
          @key         = self.class.game_key(context)
          @@games[key] = self
          @round       = 0
          @scores      = {}
          @questions   = fetch_questions
          @answers     = []
        end

        def advance
          winners.each do |answer|
            score = MAX_POINTS - ((answer.time - round_started_at) % MAX_POINTS)
            scores[answer.user] ||= 0
            scores[answer.user] += score
          end

          @answers          = []
          @round_started_at = Time.now.to_i

          @round += 1

          initialize_choices
        end

        def answer(user, choice)
          answers << Answer.new(user, Time.now.to_i, choice)
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
          @@games.delete(key)
        end

        def leaderboard
          scores.sort_by { |user, score| score }.reverse.map(&:first)[0..2]
        end

        def winners
          return [] unless round > 0

          correct_choice = current_correct_index + 1

          answers.select do |answer|
            answer.choice == correct_choice
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
