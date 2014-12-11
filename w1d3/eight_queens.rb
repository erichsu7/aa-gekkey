board = Array.new(8) { Array.new(8, false) }
def lines(x, y)
  ([x] * 8).zip((0...8).to_a) \
    + (0...8).to_a.zip([y] * 8) \
    + (0...8).to_a.zip((0...8).to_a).map { |a, b| [a - (y - x), b] } \
    + (0...8).to_a.zip((0...8).to_a.reverse).map { |a, b| [a + x - (7 - y), b] }
end

def deep_copy(board)
  Marshal.load(Marshal.dump(board))
end

def threaten(position, board)
# returns the board with all threatened spaces false
  board = deep_copy(board)

  lines(*position).each do |mod_x, mod_y|
    next unless mod_x.between?(0, 7) && mod_y.between?(0, 7)
    board[mod_x][mod_y] = true
  end
  board
end

def queens(x, current_board)
  solutions = []

  if x == 7
    current_board = deep_copy(current_board)
    if current_board.last.include?(false)
      current_board.last[current_board.last.index(false)] = 'Q'
      return [current_board]
    else
      return []
    end
  end

  8.times do |y|
    if !current_board[x][y]
      new_board = threaten([x, y], current_board)
      new_board[x][y] = 'Q'
      queens(x + 1, new_board).each do |sol|
        solutions.push(sol)
      end
    end
  end

  solutions
end

def print_board(board)
  board.each do |line|
    line.each do |char|
      print char == true ? '_' : 'Q'
    end
    print "\n"
  end
end

# test whether a queen threatens the right suares
# 8.times do |x|
#   8.times do |y|
#     puts
#     print_board(threaten([x, y], deep_copy(board)))
#   end
# end
n = 1
queens(0, board).each do |sol|
  puts "#{n}:"
  print_board(sol)
  n += 1
end
