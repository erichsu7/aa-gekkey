require 'colorize'

class Board
  attr_accessor :tiles, :size

  def initialize(size = nil, difficulty = nil) # options hash
    # merge defaults hash with options
    @size = size || 9
    @difficulty = difficulty || @size * 2
    @tiles = Array.new(@size) { |x| Array.new(@size) { |y| Tile.new(self, [x,y]) } }
  end

  def seed # refactor so no duplicate bombs
    rands = Array.new(@difficulty) { rand(@size**2 - 1) }
    rands.each do |pos|
      self[[pos/@size, pos % @size]].set(:bomb)
    end
  end

  def reveal(pos)
    if self[pos].status == :bomb
      reveal_all
      return :lose
    end

    queue = [self[pos]]
    until queue.empty?
      tile = queue.shift
      next if tile.revealed?
      tile.revealed

      tile.neighbors.each do |neighbor|
        tile.status += 1 if neighbor.status == :bomb
      end

      if tile.status == 0
        queue += tile.neighbors
      end
    end
    return :continue
  end

  def reveal_all
    @tiles.each do |row|
      row.each do |tile|
        tile.revealed
      end
    end
  end

  def flag(pos)
    self[pos].flag
  end

  def to_s(cursor_pos)
    s = ""
    # @tiles.join("\n")
    @tiles.each_with_index do |row, i1|
      row.each_with_index do |tile, i2|
        s << tile.display.colorize(:background => ([i1, i2] == cursor_pos ? :white : :none),
          :color => ([i1, i2] == cursor_pos ? :black : :none))
      end
      s << "\n"
    end
    s
  end

  def [](pos)
    x, y = pos

    if x < 0 || x >= @size || y < 0 || y >= @size
      return nil
    end

    @tiles[x][y]
  end

  def is_won?
    @tiles.each do |row|
      row.each do |tile|
        if !tile.revealed? && tile.status != :bomb
          return false
        end
      end
    end
    reveal_all
    true
  end
end
