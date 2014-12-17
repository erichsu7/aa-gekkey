class Piece
  attr_reader :pos, :color, :board, :symbol
  def initialize(pos, color, board)
    @pos, @color, @board = pos, color, board
  end

  def apply_offset(position, offset)
    [position.first + offset.first, position.last + offset.last]
  end

  def is_friend?(pos)
    return nil if @board[pos].nil?
    @board[pos].color == @color
  end

  def is_enemy?(pos)
    return nil if @board[pos].nil?
    @board[pos].color == enemy_color
  end

  def enemy_color
    @color == :blue ? :red : :blue
  end

  def off_board?(pos)
    pos.any? { |coord| !coord.between?(0,7) }
  end

  def render
    (symbol + " ").colorize(color)
  end

  def move(pos)
    @pos = pos
  end

  def dup(dup_board = @board)
    self.class.new(@pos, @color, dup_board)
  end
end

class SlidingPiece < Piece
  DIAGONALS = [1,-1].repeated_permutation(2).to_a
  ORTHOGONALS = [[1,0], [0,1], [-1,0], [0, -1]]

  def moves
    moves = []

    offsets.each do |dir|
      test_pos = apply_offset(@pos, dir)

      until off_board?(test_pos) || is_friend?(test_pos)
        moves << test_pos
        break if is_enemy?(test_pos)

        test_pos = apply_offset(test_pos, dir)
      end
    end

    moves
  end

end

class SteppingPiece < Piece
  def moves
    moves = []

    offsets.each do |dir|
      test_pos = apply_offset(@pos, dir)
      unless off_board?(test_pos) || is_friend?(test_pos)
        moves << test_pos
      end
    end

    moves
  end
end
