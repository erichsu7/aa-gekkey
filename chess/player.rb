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
#    system("clear")
    puts
    tile = [:light_black, :black]

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

  def checkmate
    puts "Checkmate!".colorize(@color)
  end

  def parse(index)
    return ' ' if index.nil?
    num, ch = index
    ("a".."h").to_a[ch] + (num + 1).to_s
  end
end
