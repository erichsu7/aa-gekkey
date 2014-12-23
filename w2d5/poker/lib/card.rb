class Card

  attr_reader :suit, :val

  def initialize(suit, val)
    @suit = suit
    @val = val
  end

  def ==(card)
    self.suit == card.suit && self.val == card.val
  end

  def <=>(card)
    card.val <=> self.val
  end

  def dup
    self.class.new(@suit, @val)
  end
end
