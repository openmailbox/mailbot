module Mailbot
  module Commands
    class Trivia
      attr_reader :user, :args

      def initialize(user, args)
        @user = user
        @args = args
      end

      def execute(context)
        Mailbot.logger.info "USER COMMAND: #{user.name} - !trivia #{args}"

        if args.first.empty?
          if current_game.nil?
            context.send_string("There is no trivia game in progress.\n\tStart a new game with '!trivia start'.")
          else
          end
        elsif args.first == 'start'
          game = Trivia::Game.new
          context.send_string("Starting a new trivia game!")
        end
      end

      private

      def answers(question)
        choices = question['incorrect_answers'] << question['correct_answer']

        choices.shuffle!

        choices.map.with_index do |choice, i|
          "#{i + 1}: #{choice}"
        end
      end

      def ask_question
        question = current_game.current_question

        text = <<~END
          TRIVIA QUESTION: #{question['question']}\n
          #{answers(question).join("\n")}\n
          Use '!trivia answer <number>' to pick an answer.
        END

        context.send_string(text)
      end

      def current_game
        @game ||= Trivia::Game.current
      end
    end
  end
end
