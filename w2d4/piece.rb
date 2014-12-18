class Piece
  OFFSETS = [[1, 1], [1, -1], [-1, 1], [-1, -1]]

  attr_reader :color, :pos
  def initialize(pos, color, board)
    @pos, @color, @board, @king = pos, color, board, false

    @direction = (color == :black ? 1 : -1)
    @moved = false

    @board[pos] = self
  end

  def apply_offset(offset, pos = @pos)
    [pos[0] + offset[0], pos[1] + offset[1]]
  end

  def directions
    if @king
      OFFSETS
    else
      ([@direction]*2).zip([1, -1])
    end
  end

  def in_bounds(pos)
    pos[0].between?(0, 9) && pos[1].between?(0, 9)
  end

  def slides
    directions.map do |dir|
      test_pos = apply_offset(dir)
      next unless in_bounds(test_pos)
      if @board[test_pos].nil?
        [test_pos, nil]
      end
    end.compact.to_h
  end

  def jumps
    OFFSETS.map do |dir|
      test_pos = apply_offset(dir)
      next if !in_bounds(test_pos) || @board[test_pos].nil?
      next if @board[test_pos].color == color
      if @board[apply_offset(dir, test_pos)].nil?
        [apply_offset(dir, test_pos), test_pos]
      end
    end.compact.to_h
  end

  def another_can_jump?
    @board.tiles.each do |row|
      row.each do |tile|
        if !tile.nil? && tile.color == color && !tile.jumps.empty?
          return true
        end
      end
    end
    false
  end

  def valid_moves
    if @moved or !jumps.empty?
      jumps
    elsif another_can_jump?
      raise InvalidMoveError.new('If can jump, must jump')
    else
      slides
    end
  end

  def move(dest)
    moves = valid_moves
    raise InvalidMoveError.new('cannot move to there') unless moves.has_key?(dest)
    @board[dest] = self
    @board[moves[dest]] = nil unless moves[dest].nil?
    @board[pos] = nil
    @pos = dest
    @moved = true

    if moves[dest].nil? # did not jump
      @moved = false
      return :end
    end

    moves = valid_moves # if jumped, check if can jump again
    if moves.empty?
      @moved = false
      return :end
    else
      return :continue
    end
  end
end