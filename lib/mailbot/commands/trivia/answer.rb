module Mailbot
  module Commands
    class Trivia
      class Answer
        attr_reader :trivia, :answer

        def initialize(trivia)
          @trivia = trivia
          @answer = trivia.args[1]
        end

        def execute
          if !current_game
            context.send_string("There is no trivia game in progress. Start a new game with '!trivia start'.")
          elsif !valid_answer?
            context.send_string("TRIVIA: Sorry, #{user.name}. That is not a valid answer choice.")
          elsif already_answered?
            context.send_string("TRIVIA: Sorry, #{user.name}. You can't change your answer.")
          elsif between_rounds?
            remaining = Trivia::BREAK_TIME - (Time.now.to_i - (current_game.round_started_at + Trivia::ROUND_TIME))
            time      = trivia.remaining_time(remaining)

            context.send_string("TRIVIA: Sorry, #{user.name}. This round is over. Next round starts in #{time}.")
          else
            current_game.answer(user, answer.to_i)
            context.send_string("TRIVIA: #{user.name}, your answer has been submitted.")
          end
        end

        private

        def already_answered?
          existing = current_game.answers.find do |answer|
            answer.user == user
          end

          !existing.nil?
        end

        def between_rounds?
          trivia.between_rounds?
        end

        def context
          trivia.context
        end

        def current_game
          Trivia::Game.current
        end

        def user
          trivia.user
        end

        def valid_answer?
          answer =~ /^\d$/ &&
            answer.to_i > 0 &&
            answer.to_i <= current_game.current_choices.length
        end
      end
    end
  end
end
