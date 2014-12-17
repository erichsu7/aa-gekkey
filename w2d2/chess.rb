require_relative 'board'
require_relative 'human_player'

class Game
  def initialize(player1, player2)
    # input here to set up players; pass board to AI
    @player1, @player2 = player1, player2
    @board = Board.new
    @player1.board = @player2.board = @board
    @player1.color = :red
    @player2.color = :blue
  end

  def run
    color = {@player1 => :red, @player2 => :blue}
    player = @player1

    until @board.checkmate?(color[player])
      begin
        @board.move(color[player], *player.turn)
      rescue InvalidMoveError => e
        player.set_error(e.message)
        retry
      end
      player = toggle(player)
    end
    player.render
    winner = color[toggle(player)]
    puts "#{winner} wins"
  end

  def toggle(player)
    player == @player1 ? @player2 : @player1
  end
end

if $PROGRAM_NAME == __FILE__
  game = Game.new(HumanPlayer.new("A"), HumanPlayer.new("B"))
  game.run
end
