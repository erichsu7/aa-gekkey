require_relative 'square'
require_relative 'pieces'

class Board
  attr_reader :king, :pieces
  def initialize
    @grid = Array.new(8) { Array.new(8) { Square.new }}
    @king = {black: nil, white: nil}
    @pieces = {black: [], white: []}
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
        #setup_pawns(row[1], color)
      end
      @pieces.each do |color, pieces_of_color|
        pieces_of_color.each do |piece|
          piece.moves
        end
      end
    end

    def setup_row(row, color)
      order = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]

      order.each_with_index do |piece, i|
        if piece == King
          @king[color] = self[[row, i]].place(piece.new([row, i], color, self))
          @pieces[color] << @king[color].piece
          next
        end
        @pieces[color] << self[[row, i]].place(piece.new([row, i], color, self)).piece
      end
    end

    def setup_pawns(row, color)
      8.times do |i|
        @pieces[color] << self[[row, i]].place(Pawn.new([row, i], color, self)).piece
      end
    end
end
