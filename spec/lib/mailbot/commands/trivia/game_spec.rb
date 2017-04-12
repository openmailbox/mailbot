require 'spec_helper'

describe Mailbot::Commands::Trivia::Game do
  around(:each) do |example|
    VCR.use_cassette('trivia/game') do
      example.run
    end
  end

  after(:each) do
    described_class.from_context(context).game_over
  end

  let(:context) do
    context = Mailbot::Context.new

    context.service = Mailbot::Models::Channel.new(name: 'test_channel')

    context
  end

  it 'maintains a list of all running games' do
    expect(described_class.games).to be_empty
    expect(described_class.from_context(context)).to be_nil

    described_class.new(context)

    expect(described_class.games).not_to be_empty
    expect(described_class.from_context(context)).not_to be_nil
  end

  it 'advances rounds' do
    game = described_class.new(context)

    expect(game.round).to eq(0)

    game.advance

    expect(game.round).to eq(1)
  end

  it 'tracks user answers' do
    game = described_class.new(context)
    user = Mailbot::Models::User.new(name: 'Tester')

    game.advance

    expect(game.answers).to be_empty

    game.answer(user, 2)

    expect(game.answers.length).to eq(1)
  end

  it 'keeps score' do
    game   = described_class.new(context)
    loser  = Mailbot::Models::User.new(name: 'Loser')
    winner = Mailbot::Models::User.new(name: 'Winner')

    game.advance

    game.answer(loser, game.current_correct_index + 1)
    game.answer(winner, game.current_correct_index + 1)

    expect(game.scores[loser]).to eq(nil)
    expect(game.scores[winner]).to eq(nil)

    game.advance

    expect(game.scores[loser]).to be > 0
    expect(game.scores[winner]).to be > 0

    game.answer(loser, game.current_correct_index + 2)
    game.answer(winner, game.current_correct_index + 1)

    game.advance

    expect(game.scores[winner]).to be > game.scores[loser]
    expect(game.leaderboard.first).to eq(winner)
  end
end
