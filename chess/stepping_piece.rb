class SteppingPiece < Piece
  def moves
    return @moves if @moves
    @moves = Set.new

    offsets.each do |dir|
      cast_ray(apply_offset(@pos, dir))
    end

    @moves
  end

  def cast_ray(test_pos, dir = nil)
    return if off_board?(test_pos)
    other_piece = @board[test_pos].piece
    if other_piece != nil
      if other_piece.color == color
        other_piece.block(self, nil)
        return
      end
    end
    @moves.add(test_pos)
    @board[test_pos].subject(self, dir)
  end

  def relieve(test_pos, dir = nil)
    @board[test_pos].relieve(self)
  end
end
