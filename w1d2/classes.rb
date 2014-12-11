class Student

  def initialize(first_name, last_name)
    @name = [first_name, last_name]
    @courses = []
  end

  def name
    @name * ' ' #puts a space between the two elements
                #shortcut to join method when done on an array
  end

  def courses
    @courses
  end

  def enroll(course)
    return if has_conflict? course
    @courses << course unless @courses.include?(course)
    course.add_student self unless course.students.include? self
  end

  def course_load
    each_load = {}
    @courses.each do |course|
      each_load[course.department] ||= 0
      each_load[course.department] += course.credits
    end
    each_load
  end

  def has_conflict?(other_course)
    @courses.each do |course|
      if course.conflicts_with? other_course
        return true
      end
    end
    false
  end
end



class Course

  attr_reader :course_name, :department, :credits, :time_block

  def initialize(course_name, department, credits, day, block)
    @students = []
    @course_name = course_name
    @department = department
    @credits = credits
    @time_block = [day, block]
  end

  def students
    @students
  end

  def add_student(student)
    @students << student unless @students.include? student
    student.enroll self unless student.courses.include? self
  end

  def conflicts_with?(other_course)
    @time_block == other_course.time_block
  end
end


class Board
  DIAGS = [[[0,0],[1,1],[2,2]],[[0,2],[1,1],[2,0]]]
  def initialize
    @board = Array.new(3) { Array.new(3, '_') }
  end

  def render
    @board.each do |line|
      line.each do |char|
        print char
      end
      print "\n"
    end
  end

  def won?
    # verticals
    temp = []
    DIAGS.each do |i|
      temp << []
      i.each do |j|
        temp.last << @board[j[0]][j[1]]
      end
    end
    ['x','o'].each do |chr|
      (@board + @board.transpose + temp).each do |i|
        return chr if i.count(chr) == 3
      end
    end
    nil
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
  end

  def play
    player = 0
    loop do
      @board.render
      if winner = @board.won?
        puts "#{winner} won!"
        break
      end

      attempted_turn = @players[player].turn
      while !@board.empty?(attempted_turn)
        attempted_turn = @players[player].turn
      end
      @board.place_mark(attempted_turn, @marks[player])
      player = (player == 1 ? 0 : 1)
    end
  end
end

class HumanPlayer
  def turn
    print '>> '
    return gets.chomp.split(' ').map { |el| el.to_i }
  end
end

class ComputerPlayer
  def turn
    puts
    return [rand(2),rand(2)]
  end
end

# board = Board.new
#
# board.place_mark([0,0], "x")
# board.render

game = Game.new(HumanPlayer.new, ComputerPlayer.new)
game.play
