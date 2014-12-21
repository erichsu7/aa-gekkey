require_relative 'keypress'
require_relative 'player'

class UserExit < StandardError
end

class HumanPlayer < Player
  def initialize(*args)
    super(*args)
    @cursor = [0, 0]
  end

  def turn
    @choices = []

    until @choices.count == 2
      render
      char = read_char
      if char == "\r"
        @choices << @cursor
      elsif char == 'q'
        puts
        raise UserExit.new
      else
        move_cursor(char)
      end
    end

    @choices
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
      @cursor[i] = 7 if @cursor[i] > 7
    end
  end
end
