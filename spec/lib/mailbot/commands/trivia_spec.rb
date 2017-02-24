require 'spec_helper'

class TestContext
  attr_reader :buffer

  def initialize
    @buffer = []
  end

  def send_string(string)
    @buffer << string
  end
end

describe Mailbot::Commands::Trivia do
  around(:each) do |example|
    VCR.use_cassette('trivia/game') do
      example.run
    end
  end

  after(:each) do
    current_game = Mailbot::Commands::Trivia::Game.current
    current_game && current_game.game_over
  end

  let(:context) { TestContext.new }
  let(:user)    { Mailbot::Models::User.new(name: 'Tester') }

  context 'with no arguments' do
    context 'when there is no game in progress' do
      it 'shows the current state of the game' do
        command = described_class.new(user, [])

        command.execute(context)

        expect(context.buffer.last).to match(/no trivia game in progress/)
      end
    end

    context 'when there is a game in progress' do
      before(:each) do
        game = Mailbot::Commands::Trivia::Game.new
        game.advance
      end

      it 'shows the active question' do
        command  = described_class.new(user, [])
        question = Mailbot::Commands::Trivia::Game.current.current_question['question']

        command.execute(context)

        expect(context.buffer.last).to match(/^TRIVIA QUESTION: '#{question}'/)
      end
    end
  end

  describe '!trivia start' do
    context 'when there is already a game in progress' do
      before(:each) do
        game = Mailbot::Commands::Trivia::Game.new
        game.advance
      end

      it 'does not start a new game' do
        command = described_class.new(user, ['start'])

        command.execute(context)

        expect(context.buffer.last).to match(/already a game in progress/)
      end
    end

    context 'when there is no game in progress' do
      it 'starts a new game' do
        command = described_class.new(user, ['start'])

        command.execute(context)

        expect(Mailbot::Commands::Trivia::Game.current).not_to be_nil
        expect(context.buffer.last).to match(/^TRIVIA QUESTION: /)
      end
    end
  end # !trivia start

  describe '!trivia answer' do
    context 'when there is no game in progress' do
      it 'shows an error' do
        command = described_class.new(user, ['answer', '1'])

        command.execute(context)

        expect(context.buffer.last).to match(/^There is no trivia game in progress/)
      end
    end

    context 'when there is a game in progress' do
      before(:each) do
        game = Mailbot::Commands::Trivia::Game.new
        game.advance
      end

      it 'submits an answer' do
        command = described_class.new(user, ['answer', '1'])

        command.execute(context)

        expect(context.buffer.last).to match(/^TRIVIA: Tester, your answer has been submitted/)
        expect(Mailbot::Commands::Trivia::Game.current.answers[0]).not_to be_empty
      end

      context 'when the answer is not an integer' do
        it 'shows an error' do
          command = described_class.new(user, ['answer', 'abc'])

          command.execute(context)

          expect(context.buffer.last).to match(/^TRIVIA: Sorry, Tester. That is not a valid answer/)
        end
      end

      context 'when there are fewer choices than the supplied answer' do
        it 'shows an error' do
          command = described_class.new(user, ['answer', '42'])

          command.execute(context)

          expect(context.buffer.last).to match(/^TRIVIA: Sorry, Tester. That is not a valid answer/)
        end
      end

      context 'when an answer has already been submitted' do
        it 'shows an error' do
          command = described_class.new(user, ['answer', '1'])

          command.execute(context)

          next_command = described_class.new(user, ['answer', '2'])

          next_command.execute(context)

          expect(context.buffer.last).to match(/^TRIVIA: Sorry, Tester\. You can't change your answer/)
        end
      end
    end # when there is a game in progress
  end # !trivia answer
end
