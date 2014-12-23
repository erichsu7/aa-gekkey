require 'set'

def apply_offset(position, offset)
  [position.first + offset.first, position.last + offset.last]
end

def off_board?(pos)
  pos[0] < 0 || pos[0] > 7 || pos[1] < 0 || pos[1] > 7
end

class Piece
  attr_reader :pos, :color, :board, :symbol, :shielding

  def initialize(pos, color, board)
    @pos, @color, @board = pos, color, board
    @shielding, @blocking = Set.new, Hash.new
    @moves = nil
  end

  def enemy_color
    @color == :white ? :black : :white
  end

  def move(dest)
    # take piece off the board
    @board[@pos].remove(self)

    # tell threatened enemies to unshield their shielded squares
    # relieve threatened squares
    moves.each do |move|
      @board[move].relieve(self)
      other_piece = @board[move].piece
      if other_piece && other_piece.color == enemy_color
        other_piece.shielding.each do |square|
          square.unguard(other_piece)
        end
      end
    end

    # tell pieces threatening your space to update their moves
    @board[@pos].lords.each do |other_piece, dir|
      other_piece.cast_ray(@pos.dup, dir)
    end

    # tell pieces you're blocking to update their moves
    @blocking.each do |other_piece, dir|
      other_piece.cast_ray(@pos.dup, dir)
    end

    # unguard shielded spaces
    @shielding.each do |square|
      @board[square].unguard(self)
    end
    @shielding = Set.new

    # change @pos
    @pos = dest

    # place piece on square at board[@pos]
    @board[@pos].place(self)

    # recalculate moves for self
    @moves = nil
    moves

    # block/shield pieces threatening square
    recast = []
    @board[@pos].lords.each do |lord, dir|
      lord.relieve(@pos.dup, dir)
      recast << [lord, @pos.dup, dir]
    end

    recast.each do |lord, pos, dir|
      lord.cast_ray(pos, dir)
    end
  end

  def block(other_piece, dir)
    @blocking[other_piece] = dir
  end

  def inspect
    "#{color} #{self.class} at #{pos}"
  end

  def valid_moves # for AI
    # king defines its own valid moves

    # if you're guarding the king, the only valid moves are to kill the threat
    #   or to move along the threatening ray
    if board.king[color].guards.include?(self)
      threat = board.king[color].guards[self]
      valid = [threat.first.pos]
      moves.each do |move|
        # if the ray cast by the threat is going in the same direction as the
        #   shadow you're casting, they are the same ray.
        if board[move].lords[threat.first] == threat.last
          valid << move
        end
      end
      return valid
    end

    case board.king[color].lords(enemy_color).size
    when 2
      []
    when 1
      valid = []
      threat = board.king[color].lords(enemy_color).first
      moves.each do |move|
        # if the square is threatened by the same piece that threatening your king
        # and the ray is going in the same direction
        # or the square's piece is the threat
        if (board[move].lords(enemy_color).include?(threat.first) &&
            board[move].lords(enemy_color)[threat.first] == threat.last) ||
            board[move].piece == threat.first
          valid << move
        end
      end
      valid
    when 0
      moves
    end
  end

  def threats
    # so that the pawn may override
    moves
  end
end
