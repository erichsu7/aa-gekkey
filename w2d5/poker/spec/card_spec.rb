require "card"

describe "Card" do

  describe "#initialize" do

    it "creates a new card" do
      card = Card.new(:♠, 3)
      expect(card.suit).to eq(:♠)
      expect(card.val).to eq(3)
    end

  end

end
