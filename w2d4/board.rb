require_relative 'piece'

class Board
  def initialize
    @tiles = Array.new(8) { Array.new(8, nil) }
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
        next if x.between?(3, 4)
        next if (x + y) % 2 == 0
        color = (x < 3 ? :black : :white )
        Piece.new([x, y], color, self)
      end
    end
  end

  def won?
    found = {white: false, black: false}

    @tiles.each do |row|
      row.each do |tile|
        found[tile.color] = true unless tile.nil?
      end
    end

    found.values.include?(false)
  end
end