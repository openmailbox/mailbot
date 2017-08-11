module Mailbot
  module Commands
    class Trivia < Mailbot::Commands::Base
      ROUND_TIME = 300 # seconds
      BREAK_TIME = 120

      enable_platform :twitch
      enable_platform :discord

      attr_reader :user, :args, :context

      def initialize(user, args)
        @user = user
        @args = args
      end

      def ask_question
        question  = HTMLEntities.new.decode(current_game.current_question['question'])
        remaining = ROUND_TIME - (Time.now.to_i - current_game.round_started_at)

        text  = "TRIVIA QUESTION #{current_game.round} of 10: '#{question}' --- "
        text << "ANSWERS: '#{answers(question).join(' ')}' --- "
        text << "Use '!trivia answer <number>' to pick an answer. "
        text << "#{remaining_time(remaining)} remaining to submit an answer for this round."

        context.send_string(text)
      end

      def between_rounds?
        Time.now.to_i > (current_game.round_started_at + ROUND_TIME)
      end

      def perform
        return unless context.service # Don't allow trivia games via private Discord message

        case args.first
        when 'start'
          Trivia::Start.new(self).execute
        when 'answer'
          Trivia::Answer.new(self).execute
        else
          return "There is no trivia game in progress. Start a new game with '!trivia start'." unless current_game

          if between_rounds?
            remaining = BREAK_TIME - (Time.now.to_i - (current_game.round_started_at + ROUND_TIME))
            "Trivia in progress. #{remaining_time(remaining)} until the next round starts."
          else
            context.send_string("Trivia in progress. Currently on question #{current_game.round} of 10.")
            ask_question
            nil
          end
        end
      end

      def remaining_time(total_seconds)
        minutes = total_seconds / 60
        text    = "#{total_seconds % 60} seconds"
        text    = "#{minutes} minutes, #{text}" if minutes > 0
        text
      end


      def start_round
        start_timer(ROUND_TIME) { end_round }
      end

      private

      def answers(question)
        current_game.current_choices.map.with_index do |choice, i|
          "#{i + 1}) #{choice}."
        end
      end

      def current_game
        Trivia::Game.from_context(context)
      end

      def end_game
        winner = current_game.leaderboard.first

        Mailbot.logger.info("TRIVIA: Ending game. Scores: #{current_game.scores.inspect}")

        text = end_round_text + "Game over! "
        text << "#{winner.name} wins with a score of #{current_game.scores[winner]}!" if winner

        current_game.game_over

        context.send_string(text)
      end

      def end_round
        if game_over?
          end_game
        else
          text = end_round_text + "The next round will start in #{BREAK_TIME / 60} minutes."

          context.send_string(text)

          start_break
        end
      end

      def end_round_text
        text =  "TRIVIA: Round ended. "
        text << "The correct answer was: #{current_game.current_question['correct_answer']}. "
        text << "The following players had the correct answer: #{current_game.winners.map { |i| i.user.name }.join(', ')}. "
        text
      end

      def game_over?
        current_game.round >= current_game.questions.length
      end

      def start_break
        start_timer(BREAK_TIME) do
          current_game.advance
          ask_question
          start_round
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
