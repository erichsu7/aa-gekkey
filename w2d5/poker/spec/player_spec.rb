require "player"
require 'deck'

describe "Player" do
  let(:game) { double("game") }
  let(:deck) { Deck.new }
  subject(:player) { Player.new("Test", 500) }

  describe "#initialize" do

    it "creates a new player with a hand and money" do
      expect(player.name).to eq("Test")
      expect(player.money).to eq(500)
    end

  end

  describe '#deal' do
    it 'is dealt a hand' do
      player.deal(Hand.new(deck))
      expect(player.hand.cards.length).to eq(5)
    end
  end

  describe '#place_bet' do

    it "decreases the player's money" do
      player.place_bet(100, 50)
      expect(player.money).to eq(400)
    end

    it "doesn't let the player bet more than they have" do
      expect { player.place_bet(500000, 50) }.to raise_error
    end

    it "doesn't let the player bet lower than the current bet" do
      expect { player.place_bet(1, 50) }.to raise_error
    end

  end
  describe '#receive_money'
  describe '#discard'

end
