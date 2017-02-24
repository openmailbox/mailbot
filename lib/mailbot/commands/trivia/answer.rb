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
          else
            current_game.answer(user, answer.to_i)
            context.send_string("TRIVIA: #{user.name}, your answer has been submitted.")
          end
        end

        private

        def already_answered?
          existing = current_game.answers.values.flatten.find { |i| i == user }
          !existing.nil?
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
