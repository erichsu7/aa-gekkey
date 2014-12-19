class Player
  CHARS = {white: ['O', 'Q'], black: ['X', 'K']}
  #CHARS = {white: ["\u26c0", "\u26c1"], black: ["\u26c2", "\u26c2"]}

  def initialize(name, board, color)
    @board, @color = board, color
    @cursor, @move, @moved, @error = [0, 0], [], nil, ""
  end

  def turn
    get_input
    move_piece
  end

  def get_input
    @move = []
    @move << @moved unless @moved.nil?
    piece = nil
    until @move.size == 2
      render
      case c = read_char
      when "\r", ' '
        @move << @cursor.dup
      when 'q'
        raise UserExit.new
      else
        move_cursor(c)
      end
    end
  end

  def move_cursor(char)
    case char
    when "\e[A"
      @cursor[0] -= 1
    when "\e[B"
      @cursor[0] += 1
    when "\e[D"
      @cursor[1] -= 1
    when "\e[C"
      @cursor[1] += 1
    end
    [0, 1].each do |i|
      @cursor[i] = 0 if @cursor[i] < 0
      @cursor[i] = 7 if @cursor[i] > 7
    end
  end

  def move_piece
    from, to = @move
    raise InvalidMoveError.new("No piece there") if @board[from].nil?
    raise InvalidMoveError.new("Not your piece") if @board[from].color != @color
    raise InvalidMoveError.new("You must keep jumping") if @moved && from != @moved
    if @board[from].move(to) == :continue
      @moved = to
      raise TurnNotOver
    end
  end

  def show_error(message)
    @error = message
  end

  def reset_turn
    @moved = nil
  end

  def render
    # trust
    system('clear')
    @board.tiles.each_with_index do |row, i|
      row.each_with_index do |tile, j|
        s = (tile.nil? ? ' ' : CHARS[tile.color][(tile.king ? 1 : 0)])
        bg = ((i + j) % 2 == 0 ? :light_black : :black)
        if @cursor == [i, j] || @move[0] == [i, j]
          bg = (@color == :white ? :light_blue : :light_red)
        end
        print s.colorize(background: bg, color: :white)
      end
      print "\n"
    end
    puts @error
    @error = ""
  end
end