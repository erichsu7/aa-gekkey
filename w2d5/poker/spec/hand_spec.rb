require 'hand'
require 'deck'

describe Hand do
  let(:deck) { Deck.new }
  subject(:hand) { Hand.new(deck) }

  describe '#initialize' do

    it "draws 5 cards" do
      expect(hand.cards.length).to eq(5)
      expect(deck.cards.length).to eq(47)
    end

  end

  describe "#discard" do

    it "discards 1 card" do
      initial_hand = Hand.new(deck)
      initial_hand.cards = hand.cards.map { |e| e.dup }
      hand.discard([0])
      expect(hand[1..4]).to eq(initial_hand[1..4])
      expect(hand[0]).not_to eq(initial_hand[0])
    end

    it "discards 3 cards" do
      initial_hand = Hand.new(deck)
      initial_hand.cards = hand.cards.map { |e| e.dup }
      hand.discard([0, 2, 4])
      expect(hand[1]).to eq(initial_hand[1])
      expect(hand[3]).to eq(initial_hand[3])
      expect(hand[0]).not_to eq(initial_hand[0])
      expect(hand[2]).not_to eq(initial_hand[2])
      expect(hand[4]).not_to eq(initial_hand[4])
    end

    it 'cannot discard more than 3 cards' do
      expect { hand.discard(5.times.to_a) }.to raise_error
    end

  end

  describe '#value' do
    it 'recognizes a straight flush' do
      straight_flush = Hand.create(deck, [[:clubs, 11],
                      [:clubs, 10],
                      [:clubs, 9],
                      [:clubs, 8],
                      [:clubs, 7]
      ])
      expect(straight_flush.type).to eq(8)
    end

    it 'recognizes four of a kind' do
      four_of_a_kind = Hand.create(deck, [[:diamonds, 2],
      [:hearts, 2],
      [:diamonds, 2],
      [:spades, 2],
      [:clubs, 6]
      ])
      expect(four_of_a_kind.type).to eq(7)
    end

    it 'recognizes a full house' do
      full_house = Hand.create(deck, [[:diamonds, 2],
      [:hearts, 2],
      [:diamonds, 2],
      [:hearts, 9],
      [:clubs, 9]
      ])
      expect(full_house.type).to eq(6)
    end

    it 'recognizes a flush' do
      flush = Hand.create(deck, [[:hearts, 2],
      [:hearts, 2],
      [:hearts, 12],
      [:hearts, 7],
      [:hearts, 6]
      ])
      expect(flush.type).to eq(5)
    end

    it 'recognizes a straight' do
      straight = Hand.create(deck, [[:diamonds, 9],
      [:hearts, 8],
      [:hearts, 7],
      [:hearts, 6],
      [:clubs, 5]
      ])
      expect(straight.type).to eq(4)
    end

    it 'recognizes three of a kind' do
      three_of_a_kind = Hand.create(deck, [[:diamonds, 2],
      [:hearts, 2],
      [:spades, 2],
      [:hearts, 7],
      [:clubs, 6]
      ])
      expect(three_of_a_kind.type).to eq(3)
    end

    it 'recognizes two pair' do
      two_pair = Hand.create(deck, [[:diamonds, 2],
      [:hearts, 2],
      [:hearts, 7],
      [:hearts, 7],
      [:clubs, 6]
      ])
      expect(two_pair.type).to eq(2)
    end

    it 'recognizes one pair' do
      one_pair = Hand.create(deck, [[:diamonds, 2],
      [:hearts, 2],
      [:hearts, 12],
      [:hearts, 7],
      [:clubs, 6]
      ])
      expect(one_pair.type).to eq(1)
    end

    it 'recognizes a high card' do
      high_card = Hand.create(deck, [[:hearts, 14],
      [:hearts, 13],
      [:clubs, 12],
      [:hearts, 10],
      [:clubs, 2]
      ])
      expect(high_card.type).to eq(0)
    end
  end

end
