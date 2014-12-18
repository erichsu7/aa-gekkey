class Board
  def initialize
    @tiles = Array.new(10) { Array.new(10, nil) }
    setup_pieces
  end

  def [](pos)
    x, y = pos
    @tiles[x][y]
  end

  def []=(pos, value)
    x, y = pos
    @tiles[x][y] = value
  end

  def tiles
    @tiles
  end

  def setup_pieces
    @tiles.each_with_index do |row, x|
      row.each_index do |y|
        next if x.between?(4, 5)
        next if (x + y) % 2 == 0
        color = (x < 4 ? :black : :white )
        Piece.new([x, y], color, self)
      end
    end
  end

  def won?
    return false
  end
end