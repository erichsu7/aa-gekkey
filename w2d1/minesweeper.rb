# Game calls Board methods; handle IO
# Board handles game logic, array of tiles

# Tile handles a single tile
require 'yaml'
require 'io/console'
require_relative './board'
require_relative './tile'
require_relative './keys'

class Game
  def initialize
    @cursor = [0, 0]
  end

  def run
    @board = setup
    system('clear')
    puts @board.to_s(@cursor)

    loop do
      status = take_input
      system('clear')
      puts @board.to_s(@cursor)
      if status == false
        break
      end
    end

    clean_up
  end

  def clean_up
    # reset terminal colors
    print "\x1b[0m"
  end

  def take_input
    case read_char
    when 'h', '?'
      print "(s)ave, (q)uit, (f)lag or (r)eveal? "
    when 's'
      print "Enter filename: "
      filename = gets.chomp
      yaml_minesweeper = YAML.dump(@board)
      File.open(filename+'.yml', 'w') { |f| f.puts(yaml_minesweeper) }
    when 'q'
      return false
    when 'f'
      @board.flag(@cursor)
    when 'r', ' '
      pos = @cursor
      if @board.reveal(pos) == :lose
        puts "You lose"
        return false
      end
    when "\e[A"
      move_cursor(:up)
    when "\e[B"
      move_cursor(:down)
    when "\e[C"
      move_cursor(:right)
    when "\e[D"
      move_cursor(:left)
    else
    end

    if @board.is_won?
      # puts time taken
      puts "A winner is you"
      return false
    end
  end

  def move_cursor(dir)
    case dir
    when :up
      @cursor = [@cursor[0] - 1, @cursor[1]]
    when :down
      @cursor = [@cursor[0] + 1, @cursor[1]]
    when :right
      @cursor = [@cursor[0], @cursor[1] + 1]
    when :left
      @cursor = [@cursor[0], @cursor[1] - 1]
    end
    2.times do |i|
      @cursor[i] = 0 if @cursor[i] < 0
      @cursor[i] = @board.size - 1 if @cursor[i] >= @board.size
    end
  end

  def setup
    yaml_minesweeper = nil

    loop do
      print "[l]oad game or [N]ew game? "
      case read_char
      when 'l'
        puts "Enter filename: "
        filename = gets.chomp
        File.open(filename+'.yml') { |f| yaml_minesweeper = YAML::load(f) }
        break
      when 'n' || ''
        print "Enter the length of your board (9): "
        board_size = gets.chomp.to_i
        print "How many bombs do you want to place (18)? "
        num_bombs = gets.chomp.to_i
        board_size = nil if board_size < 2
        num_bombs = nil if num_bombs <= 0
        yaml_minesweeper = Board.new(board_size, num_bombs)
        # yaml_minesweeper = Board.new({
        #   board_size: board_size
        #   num_bombs: num_bombs
        # })
        yaml_minesweeper.seed
        break
      else
      end
    end

    yaml_minesweeper
  end
end

game = Game.new
game.run
