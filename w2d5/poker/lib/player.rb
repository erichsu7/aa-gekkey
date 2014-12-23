require 'hand'

class Player
  attr_accessor :name, :money, :hand

  def initialize(name, money)
    @name, @money = name, money
  end

  def deal(hand)
    @hand = hand
  end

  def input
    puts @hand
    puts "Do you want to discard? (y/n) "
    to_discard = gets.chomp
    if to_discard == "y"
      puts "Select indices of cards to discard, separated by spaces"
      discard_indices = gets.chomp.split(" ").map { |elt| elt.to_i }
      @hand.discard(discard_indices)
    end
    puts "Place your bet: (0 to fold) "
    input_amount = gets.chomp.to_i
    place_bet(input_amount)
  end

  def place_bet(player_bet)
    raise "You don't have that much money!" if player_bet > @money
    @money -= player_bet
    player_bet
  end

end
