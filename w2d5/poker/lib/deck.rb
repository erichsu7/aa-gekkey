require_relative "card"

class Deck
  SUITS = [:hearts, :spades, :clubs, :diamonds]
  VALUES = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]

  attr_accessor :cards

  def self.cards
    cards = []
    SUITS.each do |suit|
      VALUES.each do |value|
        cards << Card.new(suit, value)
      end
    end
    cards
  end


  def initialize(cards = self.class.cards)
    @cards = cards
  end

  def draw(num = 1)
    raise 'not enough cards' if num > count
    @cards.pop(num)
  end

  def replace(other_cards)
    @cards = other_cards + cards
  end

  def shuffle
    self.cards.shuffle
  end

  def count
    @cards.size
  end
end
