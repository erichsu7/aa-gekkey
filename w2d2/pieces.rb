require_relative 'piece'

class Queen < SlidingPiece
  def initialize(pos, color, board)
    super
    @symbol = "\u2655"
  end

  def offsets
    DIAGONALS + ORTHOGONALS
  end
end

class Bishop < SlidingPiece
  def initialize(pos, color, board)
    super
    @symbol = "\u2657"
  end

  def offsets
    DIAGONALS
  end
end

class Rook < SlidingPiece
  def initialize(pos, color, board)
    super
    @symbol = "\u2656"
  end

  def offsets
    ORTHOGONALS
  end
end


class Knight < SteppingPiece
  def initialize(pos, color, board)
    super
    @symbol = "\u2658"
  end

  def offsets
    [[1,2],[-1,2],[1,-2],[-1,-2],[2,1],[2,-1],[-2,1],[-2,-1]]
  end
end

class King < SteppingPiece
  def initialize(pos, color, board)
    super
    @symbol = "\u2654"
  end

  def offsets
    [1,0,-1].repeated_permutation(2).to_a - [[0,0]]
  end
end

class Pawn < Piece

  def initialize(pos, color, board)
    super
    @symbol = "\u2659"
  end

  def distances
    moved? ? [1] : [1, 2]
  end

  def moved?
    @pos[0] != (color == :red ? 1 : 6)
  end

  def direction
    color == :red ? 1 : -1
  end

  def moves
    moves = []

    distances.each do |distance|
      test_pos = apply_offset(@pos, [direction * distance, 0])
      break unless @board[test_pos].nil?
      moves << test_pos unless off_board?(test_pos)
    end

    [1, -1].each do |diag|
      test_pos = apply_offset(@pos, [direction, diag])
      moves << test_pos if is_enemy?(test_pos)
    end

    moves
  end

end
