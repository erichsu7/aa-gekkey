require "deck"

describe "Deck" do
  subject(:deck) { Deck.new(Deck.cards) }

  describe "#initialize" do
    it "is initialized to 52 cards" do
      expect(deck.cards.length).to eq(52)
    end
  end

  describe "#draw" do

    it "draws 1 card" do
      dia14 = Card.new(:diamonds, 14)
      expect(deck.draw()).to eq([dia14])
    end

    it "draws 5 cards" do
      dia10 = Card.new(:diamonds, 10)
      dia11 = Card.new(:diamonds, 11)
      dia12 = Card.new(:diamonds, 12)
      dia13 = Card.new(:diamonds, 13)
      dia14 = Card.new(:diamonds, 14)
      expect(deck.draw(5)).to eq([dia10, dia11, dia12, dia13, dia14])
    end

    it 'cannot draw cards from the aether' do
      deck = Deck.new([Card.new(:diamonds, 10)])

      expect { deck.draw(2) }.to raise_error
    end
  end

  describe "#shuffle" do

    it "shuffles cards" do
      other_deck = Deck.new
      other_deck.shuffle
      expect(deck.cards).not_to eq(other_deck)
    end

  end

  describe "#replace" do

    it "replaces 1 card" do
      dia2 = Card.new(:diamonds, 2)
      deck.replace([dia2])
      expect(deck.cards[0]).to eq(dia2)
    end

    it "replaces multiple cards" do
      dia2 = Card.new(:diamonds, 2)
      dia3 = Card.new(:diamonds, 3)
      dia4 = Card.new(:diamonds, 4)
      deck.replace([dia2, dia3, dia4])
      expect(deck.cards[0..2]).to eq([dia2, dia3, dia4])
    end

  end

  describe "#count" do
    it 'is 52 when initialized' do
      expect(deck.count).to eq(52)
    end

    it 'is 47 after 5 are drawn' do
      deck.draw(5)
      expect(deck.count).to eq(47)
    end

  end

end
