require 'ruby-prof'

require_relative 'board'
require_relative 'errors'
require_relative 'human_player'
#require_relative 'computer_player'

class Game
  def initialize(player1, player2, board = Board.new)
    # input here to set up players; pass board to AI
    @board = board
    @player1, @player2 = player1, player2
  end

  def run
    player = @player1

    until false # @board.checkmate?(player.color)
      begin
        @board.move(player.color, player.turn)
      rescue InvalidMoveError => e
        player.set_error(e.message)
        retry
      rescue UserExit
        return
      end
      player = toggle(player)
    end
    player.render(true)
    toggle(player).checkmate
  end

  def toggle(player)
    player == @player1 ? @player2 : @player1
  end
end

if $PROGRAM_NAME == __FILE__
  RubyProf.start

  board = Board.new
  # game = Game.new(
  #   HumanPlayer.new("not AI", board, :red),
  #   HumanPlayer.new("Human", board, :blue),
  #   board
  # )
  # game.run
  1_000_000.times do
    board[[0, 0]].piece.valid_moves
  end

  result = RubyProf.stop
  printer = RubyProf::FlatPrinter.new(result)
  printer.print(STDOUT)
end
