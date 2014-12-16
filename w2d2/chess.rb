class Piece
  # all common piece methods and variables
end

class SteppingPiece < Piece
  # valid_moves method for knight and king
  def knight(pos)
    # here be linear algebra !
    base_moves = [[1] * 4, [2] * 4]
    base_moves = base_moves.transpose + base_moves.reverse.transpose
    modifier = [1, -1].repeated_permutation(2).to_a * 2
    moves = base_moves.each_with_index.map do |v, i|
      [pos[0] + v[0] * modifier[i][0], pos[1] + v[1] * modifier[i][1]]
    end
    moves.select { |x, y| (0..7).include?(x) && (0..7).include?(y) }
  end
end

class SlidingPiece < Piece
  # valid_moves methods for bishop, rook, queen
  #   perpendicular moves
  #   ([x] * 8).zip((0...8).to_a) + (0...8).to_a.zip([y] * 8)
  #   diagonal moves
  #   both
      + (0...8).to_a.zip((0...8).to_a).map { |a, b| [a + x - y, b] } \
      + (0...8).to_a.zip((0...8).to_a.reverse).map { |a, b| [a + x - (7 - y), b] }
end

class Queen < SlidingPiece
end
