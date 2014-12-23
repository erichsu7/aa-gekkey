class SlidingPiece < Piece
  DIAGONALS = [[1, 1], [-1, 1], [-1, -1], [1, -1]]
  ORTHOGONALS = [[1, 0], [0, 1], [-1, 0], [0, -1]]

  def moves
    return @moves if @moves
    @moves = Set.new

    offsets.each do |dir|
      cast_ray(apply_offset(@pos, dir), dir)
    end

    @moves
  end

  def cast_ray(test_pos, dir)
    until off_board?(test_pos)
      other_piece = @board[test_pos].piece
      if other_piece != nil
        if other_piece.color == color
          other_piece.block(self, dir)
          break
        else
          @moves.add(test_pos)
          @board[test_pos].subject(self, dir)
          cast_shield(test_pos, dir)
          break
        end
      end
      @board[test_pos].subject(self, dir)
      @moves.add(test_pos)
      test_pos = apply_offset(test_pos, dir)
    end
  end

  def cast_shield(test_pos, dir)
    other_pieces = [@board[test_pos].piece]
    test_pos = apply_offset(test_pos, dir)
    until off_board?(test_pos)
      other_pieces.each do |other_piece|
        @board[test_pos].guard(other_piece, self, dir)
      end
      if @board[test_pos].piece
        if @board[test_pos].piece.color == color
          other_piece.block(self, dir)
          break
        else
          other_pieces << @board[test_pos].piece
        end
      end

      test_pos = apply_offset(test_pos, dir)
    end
  end

  def relieve(test_pos, dir)
    until off_board?(test_pos)
      @board[test_pos].relieve(self)

      test_piece = @board[test_pos].piece
      if test_piece #&& @board[test_pos].guards[test_piece] == self
        p @board[test_pos].guards[test_piece]
        @board[test_pos].unguard(test_piece)
      end

      test_pos = apply_offset(test_pos, dir)
    end
  end
end
