# Game creates a board, shows it to the players, and asks for their input
# Board is a 2d array with a method to set itself up
# players see the board and tell a piece how to move
# the piece uses the board to find other pieces and tell the game if it can move there

# questions:
# refactoring - turn long function into multiple, single-use functions?
# using exceptions to send signals?

require 'colorize'
require_relative 'keypress'
require_relative 'board'
require_relative 'player'
require_relative 'errors'

class Game
  def initialize()
    @board = Board.new
    @player = [nil, # little hack; to change the player, multiply by -1
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
        @player[i].show_error(e.message)
        retry
      rescue TurnNotOver
        retry
      rescue UserExit
        return
      end
      @player[i].reset_turn
      i *= -1
    end
    puts "#{player[i * -1]} won!"
  end
end

# testing
game = Game.new
game.play
