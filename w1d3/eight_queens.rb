class Board
  def initialize(value = nil)
    @store = value || Array.new(8) { Array.new(8, false) } 
  end

  def [](x)
    @store[x]
  end

  def lines(x, y)
  # returns a list of indices in line with [x, y]
    ([x] * 8).zip((0...8).to_a) \
      + (0...8).to_a.zip([y] * 8) \
      + (0...8).to_a.zip((0...8).to_a).map { |a, b| [a + x - y, b] } \
      + (0...8).to_a.zip((0...8).to_a.reverse).map { |a, b| [a + x - (7 - y), b] }
  end

  def deep_copy
    self.class.new(Marshal.load(Marshal.dump(@store)))
  end

  def threaten(position)
  # returns the board with all threatened spaces false
    lines(*position).each do |mod_x, mod_y|
      # diagonals are shifted across the x axis depending on x and y
      # So that a portion of it may pushed off the board, or loop around
      # We want to ignore that portion
      next unless mod_x.between?(0, 7) && mod_y.between?(0, 7)

      @store[mod_x][mod_y] = true
    end
    @store[position[0]][position[1]] = 'Q'
  end

  def to_s
    @store.each do |line|
      line.each do |char|
        print char == true ? '_' : 'Q'
      end
      print "\n"
    end
  end
end

def queens(x, current_board)
  solutions = []

  if x == 7
    current_board = current_board.deep_copy
    return [] unless i = current_board[x].index(false)
    current_board.threaten([x, i])
    return [current_board]
  end

  8.times do |y|
    if !current_board[x][y]
      new_board = current_board.deep_copy
      new_board.threaten([x, y])
      queens(x + 1, new_board).each do |sol|
        solutions.push(sol)
      end
    end
  end

  solutions
end

board = Board.new
n = 0
queens(0, board).each do |sol|
  puts "#{n += 1}:"
  puts sol
end
