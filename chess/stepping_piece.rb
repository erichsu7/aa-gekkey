class SteppingPiece < Piece
  def moves
    return @moves if @moves
    @moves = Set.new

    offsets.each do |dir|
      test_pos = apply_offset(@pos, dir)
      unless off_board?(test_pos) || is_friend?(test_pos)
        @moves.add(test_pos)
      end
    end

    @moves
  end

  def cast_ray(test_pos, dir = nil)
  end

  def cast_shield(test_pos, dir = nil)
  end
end
