require_relative 'square'
require_relative 'pieces'

class Board
  attr_reader :king
  def initialize
    @grid = Array.new(8) { Array.new(8) { Square.new }}
    @king = {black: nil, white: nil}
    setup_board
  end

  def [](pos)
    x, y = pos
    @grid[x][y]
  end

  private
    def setup_board
      order = {black: [0, 1], white: [7, 6]}.each do |color, row|
        setup_row(row[0], color)
        setup_pawns(row[1], color)
      end
    end

    def setup_row(row, color)
      order = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]

      order.each_with_index do |piece, i|
        if piece == King
          @king[color] = self[[row, i]].place(piece.new([row, i], color, self))
        else
          self[[row, i]].place(piece.new([row, i], color, self))
        end
      end
    end

    def setup_pawns(row, color)
      8.times do |i|
        self[[row, i]].place(Pawn.new([row, i], color, self))
      end
    end
end
