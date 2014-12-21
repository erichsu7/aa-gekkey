require 'colorize'

class NilClass
  def render
    "  "
  end
end

class Player
  attr_accessor :name, :board, :color

  def initialize(name, board, color)
    @name = name
    @board = board
    @color = color
    @error = nil
    @cursor = nil
    @choices = []
  end

  def set_error(message)
    @error = message
  end

  def render(game_ended = false)
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
    print "#{@name.colorize(color)}, what's your move? " unless game_ended
  end

  def pieces #pieces array might be faster
    @board.find{ |piece| piece.color == @color}
  end

  def moves
    # this method is contrived
    arr = []

    pieces.each do |piece|
      piece.moves.each do |move|
        arr << [piece.pos, move]
      end
    end

    arr
  end

  def checkmate
    puts "Checkmate!".colorize(@color)
  end

  def enemy_color
    toggle_color(@color)
  end

  def toggle_color(color)
    color == :blue ? :red : :blue
  end

  def parse(index)
    return ' ' if index.nil?
    num, ch = index
    ("a".."h").to_a[ch] + (num + 1).to_s
  end
end
