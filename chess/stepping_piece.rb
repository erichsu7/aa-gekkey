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
        @blocked_by.add(other_piece)
      else
        @moves.add(test_pos)
        @board[test_pos].subject(self, dir)
      end
    else
      @moves.add(test_pos)
    end
  end

  def cast_shield(test_pos, dir = nil)
  end
end
