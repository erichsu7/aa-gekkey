require "game"

describe "Game" do

  describe "#initialize" do

    it "has a deck" do
      game = Game.new
      expect(game.deck.length).to eq(52)
    end

  end

end
