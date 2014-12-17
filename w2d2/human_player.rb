require 'colorize'
require_relative 'keypress'

class NilClass
  def render
    "  "
  end
end

class HumanPlayer
  attr_accessor :board, :color

  def initialize(name, board = nil)
    @name = name
    @board = board
    @error = nil
    @cursor = [0, 0]
    @choices = []
  end

  def render
    system("clear")
    tile = [:white, :black]

    puts "  #{("a".."h").to_a.join(" ")}"
    8.times do |i|
      print "#{i + 1} "
      8.times do |j|
        symbol = @board[[i, j]].render
        bg = (@cursor == [i, j] ? :green : tile[(i + j) % 2])
        print symbol.colorize(:background => bg)
      end
      ending = " "
      if i == 0
        ending += parse(@choices[0])
      elsif i == 2
        ending += parse(@choices[1])
      end
      puts ending
    end
    puts @error.to_s.colorize(:yellow)
    @error = nil
    print "#{@name}, what's your move? "
  end

  def set_error(message)
    @error = message
  end

  def parse(index)
    return ' ' if index.nil?
    num, ch = index
    ("a".."h").to_a[ch] + (num + 1).to_s
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
        exit
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
