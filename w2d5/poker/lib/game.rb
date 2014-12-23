class Game

  attr_accessor :curr_bet

  def initialize(deck, players)
    @deck, @players = deck, players
    @curr_bet = 0
  end

  def play
    # asks a player for input until one does not raise an error
    #   fold (0), see (current_bet), raise(greater)
    players.each do |player|
      bet = player.input
      if bet < current_bet
        #player folds
      else
        bet = current_bet
      end
    end
    # raise "You have to bet more than the current bet" if current_bet > player_bet
  end

end
