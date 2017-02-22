module Mailbot
  module Commands
    class Trivia
      ROUND_TIME = 30 # seconds
      BREAK_TIME = 60

      attr_reader :user, :args, :context

      def initialize(user, args)
        @user = user
        @args = args
      end

      def execute(context)
        Mailbot.logger.info "USER COMMAND: #{user.name} - !trivia #{args}"

        @context = context

        if args.empty?
          if current_game.nil?
            context.send_string("There is no trivia game in progress. Start a new game with '!trivia start'.")
          else
            context.send_string("Trivia in progress. Currently on question #{current_game.round} of 10.")
            ask_question
          end
        elsif args.first == 'start'
          if current_game.nil?
            context.send_string("Starting a new trivia game!")
            @game = Trivia::Game.new
            current_game.advance
            ask_question

            start_timer(ROUND_TIME) do
              end_round
            end
          else
            context.send_string('There is already a game in progress!')
          end
        elsif args.first == 'answer'
          if args[1] =~ /\d/ && args[1].to_i <= current_game.current_choices.length
            if current_game.answers.values.flatten.find { |i| i == user }
              context.send_string("TRIVIA: Sorry, #{user.name}. You can't change your answer.")
            else
              current_game.answer(user, args[1].to_i)
              context.send_string("TRIVIA: #{user.name}, your answer has been submitted.")
            end
          else
            context.send_string("TRIVIA: Sorry, #{user.name}. That is not a valid answer choice.")
          end
        end
      end

      private

      def answers(question)
        current_game.current_choices.map.with_index do |choice, i|
          "#{i + 1}) #{choice}."
        end
      end

      def ask_question
        question  = current_game.current_question
        remaining = ROUND_TIME - (Time.now.to_i - current_game.round_started_at)

        text  = "TRIVIA QUESTION: '#{question['question']}' --- "
        text << "ANSWERS: '#{answers(question).join(' ')}' --- "
        text << "Use '!trivia answer <number>' to pick an answer. "
        text << "#{remaining} seconds remaining to submit an answer for this round."

        context.send_string(text)
      end

      def current_game
        @game ||= Trivia::Game.current
      end

      def end_round
        text =  "TRIVIA: Round ended. "
        text << "The correct answer was: #{current_game.current_question['correct_answer']}. "
        text << "The following players had the correct answer: #{current_game.winners.map(&:name).join(', ')}. "

        if current_game.round >= current_game.questions.length
          winner, score = current_game.scores.sort_by { |i, j| j }.last

          text << "Game over! #{winner.name} wins with a score of #{score}!"

          current_game.game_over

          context.send_string(text)
        else
          text << "The next round will start in #{BREAK_TIME} seconds."

          context.send_string(text)

          start_timer(BREAK_TIME) do
            current_game.advance
            ask_question
          end
        end
      end

      def start_timer(seconds, &block)
        Thread.start do
          sleep(seconds)
          yield
        end
      end
    end
  end
end
