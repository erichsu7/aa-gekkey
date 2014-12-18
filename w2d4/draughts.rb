# Game creates a board, shows it to the players, and asks for their input
# Board is a 2d array with a method to set itself up
# players see the board and tell the a piece how to move
# the piece uses the board to find other pieces and tell the game if it can move there

# TODO
# promotion

require 'colorize'
require_relative 'keypress'

class Game
  def initialize()
    @board = Board.new
    @player = [nil,
               Player.new('player 1', @board, :white),
               Player.new('player 2', @board, :black)
    ]
  end

  def play
    i = 1
    until @board.won?
      begin
        @player[i].turn
      rescue InvalidMoveError => e
        puts e.message
        retry
      rescue TurnNotOver
        retry
      rescue UserExit
        return
      end
      @player[i].reset_turn
      i *= -1
    end
  end
end

# testing
game = Game.new
game.play

# board = Board.new
# board.render
# puts

# board[[3, 0]].move([4, 1])
# board.render
# puts

# board[[4, 1]].move([5, 2])
# board.render
# puts

# p board[[6, 1]].valid_moves
