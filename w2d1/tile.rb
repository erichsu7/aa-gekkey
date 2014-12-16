class Tile
  ADJACENT = [
    [1, 1],
    [1, 0],
    [1, -1],
    [0, 1],
    [0, -1],
    [-1, 1],
    [-1,0],
    [-1,-1]
  ]
  COLOR = {
    0 => :black,
    1 => :blue,
    2 => :green,
    3 => :light_red,
    4 => :magenta,
    5 => :red,
    6 => :cyan,
    7 => :black,
    8 => :grey}

  attr_accessor :status
  attr_reader :display

  def initialize(board, pos)
    @board = board
    @pos = pos
    @status = 0
    @revealed = false
    @flagged = false
  end

  def set(status)
    @status = status
  end

  def display
    return '⚑'.colorize(:red) if @flagged
    if @revealed
      if @status == 0
        return ' '
      elsif @status.is_a?(Integer)
        return @status.to_s.colorize(COLOR[@status])
      else
        return 'X'
      end
    end
    '*'
  end

  def neighbors
    arr = []
    ADJACENT.each do |pos|
      tile = @board[[@pos[0] + pos[0], @pos[1] + pos[1]]]
      arr << tile unless tile.nil?
    end
    arr
  end

  def revealed
    @revealed = true
  end

  def revealed?
    @revealed
  end

  def flag
    @flagged = !@flagged
  end
end
