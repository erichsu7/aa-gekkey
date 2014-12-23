require_relative "deck"
require_relative "card"

class Hand
  SUIT_CHARS = {spades: '♠', clubs: '♣', hearts: '♥', diamonds: '♦'}
  VALUE_CHARS= {2 => '2 ', 3 => '3 ', 4 => '4 ', 5 => '5 ', 6 => '6 ', 7 => '7 ',
    8 => '8 ', 9 => '9 ', 10 => '10', 11 => 'J ', 12 => 'Q ', 13 => 'K ', 14 => 'A '}

  attr_accessor :deck, :cards

  def self.create(deck, arr)
    cards = []

    arr.each do |s, v|
      cards << Card.new(s, v)
    end

    self.new(deck, cards)
  end

  def initialize(deck, cards = nil)
    @deck = deck
    @cards = cards || deck.draw(5)
  end

  def discard(arr)
    raise 'cannot discard more than 3 cards' if arr.size > 3
    arr.each do |i|
      deck.replace([@cards[i]])
      @cards[i] = deck.draw.first
    end
  end

  def [](pos)
    @cards[pos]
  end

  def to_s
    @cards.map do |card|
      SUIT_CHARS[card.suit] + VALUE_CHARS[card.val]
    end.join(' ')
  end

  def sort!
    @cards = (cards.sort)
  end

  def value
    @cards.sort!
    p @cards
    mul = 1_00_00_00_00_00
    val = type * mul
    mul /= 100
    already_counted = []

    @cards.each do |card|
      unless already_counted.include?(card.val)
        val += card.val * mul
        mul /= 100
        already_counted << card.val
      end
    end

    val
  end

  def type
    hand_types = [:straight_flush, :four_of_a_kind, :full_house, :flush,
      :straight, :three_of_a_kind, :two_pair, :one_pair, :high_card]
    hand_types.each_with_index do |hand_type, i|
      if self.send(hand_type)
        return 8 - i
      end
    end
  end

  def n_of_a_kind(n, m = 1)
    count = Hash.new(0)
    @cards.each do |card|
      count[card.val] += 1
    end
    count.values.count(n) == m
  end

  def straight_flush
    straight && flush
  end

  def four_of_a_kind
    n_of_a_kind(4)
  end

  def full_house
    three_of_a_kind && one_pair
  end

  def flush
    (1..4).each do |i|
      if @cards[0].suit != @cards[i].suit
        return false
      end
    end
    true
  end

  def straight
    (0..3).each do |i|
      if @cards[i].val != @cards[i + 1].val + 1
        return false
      end
    end
    true
  end

  def three_of_a_kind
    n_of_a_kind(3)
  end

  def two_pair
    n_of_a_kind(2, 2)
  end

  def one_pair
    n_of_a_kind(2)
  end

  def high_card
    true
  end

end
