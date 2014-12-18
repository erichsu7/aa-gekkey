class Player
  CHARS = {white: ['O', 'Q'], black: ['X', 'K']}
  #CHARS = {white: ["\u26c0", "\u26c1"], black: ["\u26c2", "\u26c2"]}

  def initialize(name, board, color)
    @board, @color = board, color
    @cursor, @move, @moved = [0, 0], [], nil
  end

  def turn
    @move = []
    piece = nil
    until @move.size == 2
      render
      case c = read_char
      when "\r", ' '
        @move << @cursor
      when 'q'
        raise UserExit.new
      else
        move_cursor(c)
      end
    end
    # from, to = gets.chomp.split(' ').map { |x| x.split(',') .map { |y| Integer(y) } }
    from, to = @move
    raise InvalidMoveError.new("No piece there") if @board[from].nil?
    raise InvalidMoveError.new("Not your piece") if @board[from].color != @color
    raise InvalidMoveError.new("You must keep jumping") if @moved && from != @moved
    if @board[from].move(to) == :continue
      @moved = to
      @move.pop
      raise TurnNotOver
    end
  end

  def reset_turn
    @moved = nil
  end

  def render
    system('clear')
    @board.tiles.each_with_index do |row, i|
      row.each_with_index do |tile, j|
        s = (tile.nil? ? ' ' : CHARS[tile.color][0])
        bg = ((i + j) % 2 == 0 ? :black : :light_black)
        if @cursor == [i, j] || @move[0] == [i, j]
          bg = (@color == :white ? :light_blue : :light_red)
        end
        print s.colorize(background: bg, color: :white)
      end
      print "\n"
    end
  end

  def move_cursor(char)
    case char
    when "\e[A"
      @cursor = [@cursor[0] - 1, @cursor[1]]
    when "\e[B"
      @cursor = [@cursor[0] + 1, @cursor[1]]
    when "\e[D"
      @cursor = [@cursor[0], @cursor[1] - 1]
    when "\e[C"
      @cursor = [@cursor[0], @cursor[1] + 1]
    end
    [0, 1].each do |i|
      @cursor[i] = 0 if @cursor[i] < 0
      @cursor[i] = 9 if @cursor[i] > 9
    end
  end
end