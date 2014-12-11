class Board
  DIAGS = [[[0,0],[1,1],[2,2]],[[0,2],[1,1],[2,0]]]
  def initialize(assign = nil)
    @board = assign || Array.new(3) { Array.new(3, '_') }
  end

  def render
    @board.each do |line|
      line.each do |char|
        print char
      end
      print "\n"
    end
  end

  def inspect
    temp = []
    3.times do |x|
      temp << []
      3.times do |y|
        temp.last << @board[x][y]
      end
    end
    temp
  end

  def won?
    # verticals
    ['x','o'].each do |chr|
      (@board + @board.transpose).each do |i|
        return chr if i.count(chr) == 3
      end

      DIAGS.each do |i|
        temp = []
        i.each do |j|
          temp << @board[j[0]][j[1]]
        end
        return chr if temp.count(chr) == 3
      end
    end
    nil
  end

  def draw?
    @board.each do |line|
      line.each do |i|
        return false if i == '_'
      end
    end
    true
  end

  def empty?(pos)
    @board[pos[0]][pos[1]] == '_'
  end

  def place_mark(pos, mark)
    @board[pos[0]][pos[1]] = mark
  end
end


class Game
  def initialize(*players)
    @board = Board.new
    @players = players
    @marks = ['x', 'o']
    2.times { |i| players[i].reveal @board, @marks[i] }
  end

  def play
    player = 0
    loop do
      @board.render
      if winner = @board.won?
        puts "#{winner} won!"
        break
      end
      if @board.draw?
        puts "draw!"
        break
      end

      attempted_turn = @players[player].turn
      while !@board.empty?(attempted_turn)
        attempted_turn = @players[player].turn
      end
      @board.place_mark(attempted_turn, @marks[player])

      if @players[0].TYPE == 'computer' && @players[1].TYPE == 'computer'
        gets
      end

      player = (player == 1 ? 0 : 1)
    end
  end
end

class HumanPlayer
  def reveal(board, chr)
    @chr = chr
  end

  def turn
    print "#{@chr}'s turn: "
    return gets.chomp.split(' ').map { |el| el.to_i }
  end
end

class ComputerPlayer
  DIAGS = [[[0,0],[1,1],[2,2]],[[0,2],[1,1],[2,0]]]
  ORDER_OF_PLAY = [:win, :fork, :center, :opposite_corner, :empty_corner, :empty_side, :fuckit]
  @@TYPE = 'computer'
  attr_reader :TYPE

  def reveal(board, chr)
    @board, @chr = board, chr
    @o_chr = @chr == 'x' ? 'o' : 'x'
  end

  def won? test_board
    ['x','o'].each do |chr|
      temp = []
      DIAGS.each do |i|
        temp << []
        i.each do |j|
          temp.last << test_board[j[0]][j[1]]
        end
      end
      (test_board + test_board.transpose + temp).each do |i|
        return chr if i.count(chr) == 3
      end
    end
    nil
  end
  def rows_including x, y
    temp = []
    [[x, x, x].zip([0, 1, 2]), [0, 1, 2].zip([y, y, y]), DIAGS[0].include?([x, y]) ? DIAGS[0] : [], DIAGS[1].include?([x, y]) ? DIAGS[1] : []].each do |i|
      temp << []
      i.each do |x, y|
        temp.last << @board.inspect[x][y]
      end
    end
    temp
  end

  # strategies
  def win
    3.times do |x|
      3.times do |y|
        ['x','o'].each do |z|
          test_board = @board.inspect
          test_board[x][y] = z if test_board[x][y] == '_'

          result = won?(test_board)
          if !result.nil?
            return [x,y]
            # if either you or your oponent win by placing a mark there, take that spot
          end
        end
      end
    end
    return 'inconclusive'
  end
  def fork
    # create a hypothetical
    potential_forks = {'x' => [], 'o' => []}
    ['x','o'].each do |z|
      3.times do |x|
        3.times do |y|
          potential_victories = {'x' => 0, 'o' => 0}
          test_board = @board.inspect
          test_board[x][y] = z if test_board[x][y] == '_'

          #check if it results in a fork
          ['x','o'].each do |chr|
            temp = []
            DIAGS.each do |i|
              temp << []
              i.each do |j|
                temp.last << test_board[j[0]][j[1]]
              end
            end
            (test_board + test_board.transpose + temp).each do |i|
              potential_victories[chr] += 1 if i.count(chr) == 2 && i.count('_') == 1
            end
          end
          # if placing a mark in that spot allows 2 rows of two ending
          # in a blank space, take that space before they can
          # but only if thats the only fork they can make
          # otherwise force them to block you
          if potential_victories['x'] == 2
            potential_forks['x'] << [x, y]
          elsif potential_victories['o'] == 2
            potential_forks['o'] << [x, y]
          end
        end
      end
    end
    if potential_forks[@chr].count > 0
      return potential_forks[@chr].first
    elsif potential_forks[@o_chr].count > 1
      # force a block
      test_board = @board.inspect
      possible_moves = []
      3.times do |x|
        3.times do |y|
          rows_including(x, y).each do |i|
            possible_moves << [x, y] if i.count(@chr) == 1 && i.count('_') == 2 && test_board[x][y] == '_' && potential_forks[@o_chr].include?([x, y])
          end
        end
      end
      return possible_moves.sample
    elsif potential_forks[@o_chr].count > 0
      return potential_forks[@o_chr].first
    end
    return 'inconclusive'
  end
  def center
    return [1, 1] if @board.inspect[1][1] == '_'
    return 'inconclusive'
  end
  def opposite_corner
    return 'inconclusive'
  end
  def empty_corner
    test_board = @board.inspect
    possible_moves = []
    [0,0,2,2].repeated_combination(2).each do |x, y|
      possible_moves << [x, y] if test_board[x][y] == '_'
    end
    possible_moves.sample || 'inconclusive'
  end
  def empty_side
    test_board = @board.inspect
    possible_moves = []
    3.times do |x|
      3.times do |y|
        possible_moves << [x, y] if test_board[x][y] == '_'
      end
    end
    possible_moves.sample || 'inconclusive'
  end
  def fuckit
    return [rand(2), rand(2)]
  end

  def turn
    print "#{@chr}'s turn: "
    ORDER_OF_PLAY.each do |move|
      # print "trying to " + move.to_s + "\n"
      if (x = self.send(move)) != 'inconclusive'
        print "\n"
        return x
      end
    end
  end
end

# ai = ComputerPlayer.new
# board = Board.new
# ai.reveal(board, 'o')
# board.place_mark([0,0], "x")
# board.place_mark([1,1], "o")
# board.place_mark([2,2], "x")
# board.place_mark(ai.turn, 'o')
# p board.won?
# board.render

game = Game.new(ComputerPlayer.new, ComputerPlayer.new)
game.play
