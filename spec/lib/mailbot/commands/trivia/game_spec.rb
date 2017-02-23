require 'spec_helper'

describe Mailbot::Commands::Trivia::Game do
  around(:each) do |example|
    VCR.use_cassette('trivia/game') do
      example.run
    end
  end

  after(:each) do
    described_class.current && described_class.current.game_over
  end

  it 'maintains a single instance of the current game' do
    expect(described_class.current).to be_nil

    described_class.new

    expect(described_class.current).not_to be_nil
  end

  it 'advances rounds' do
    game = described_class.new

    expect(game.round).to eq(0)

    game.advance

    expect(game.round).to eq(1)
  end

  it 'tracks user answers' do
    game = described_class.new
    user = Mailbot::Models::User.new(name: 'Tester')

    game.advance

    expect(game.answers[1]).to be_nil

    game.answer(user, 2)

    expect(game.answers[1]).not_to be_empty
    expect(game.answers[1].first).to eq(user)
  end

  it 'keeps score' do
    game   = described_class.new
    loser  = Mailbot::Models::User.new(name: 'Loser')
    winner = Mailbot::Models::User.new(name: 'Winner')

    game.advance

    game.answer(loser, game.current_correct_index + 1)
    game.answer(winner, game.current_correct_index + 1)

    expect(game.scores[loser]).to eq(nil)
    expect(game.scores[winner]).to eq(nil)

    game.advance

    expect(game.scores[loser]).to eq(1)
    expect(game.scores[winner]).to eq(1)

    game.answer(loser, game.current_correct_index + 2)
    game.answer(winner, game.current_correct_index + 1)

    game.advance

    expect(game.scores[loser]).to eq(1)
    expect(game.scores[winner]).to eq(2)
    expect(game.leaderboard.first).to eq(winner)
  end
end
