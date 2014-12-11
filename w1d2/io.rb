def guessing_game
  correct = rand(99)+1
  times_guessed = 0
  guess = ''

  while guess != correct
    times_guessed += 1
    puts "Please choose a number 1-100."
    guess = gets.chomp.to_i
    if guess > correct
      puts "Your guess is too high."
    elsif guess < correct
      puts "Your guess is too low."
    end
  end

  puts "Your guess was correct. It took you #{times_guessed} guesses."
end

class RPNCalculator
  def initialize
    @stack = []
  end

  def pop
    raise 'Error, stack is empty' if @stack.empty?
    @stack.pop
  end

  def push(number)
    @stack.push(number)
  end

  def value
    @stack.last || 0
  end

  def plus
    @stack.push(pop + pop)
  end

  def minus
    @stack.push(-pop + pop)
  end

  def times
    @stack.push(pop * pop)
  end

  def divide
    @stack.push( ( 1.0 / pop ) * pop )
  end

  def +
    plus
  end
  def -
    minus
  end
  def *
    times
  end
  def /
    divide
  end

  def apply(command)
    if command.to_i.to_s == command
      push command.to_i
    elsif [:+, :-, :*, :/].include? command.to_sym
      self.send(command.to_sym)
    elsif command == 'q'
      return false
    else
      raise "Error: invalid command"
    end
    true
  end

  def run
    loop do
      print "#{@stack.to_s} >> "
      break unless apply(gets.chomp)
    end
  end

  def parse(str)
    str.split(' ').each do |command|
      apply(command)
    end
    pop
  end
end

# if __FILE__ == $PROGRAM_NAME
#   cal = RPNCalculator.new
#   if !ARGV[0].nil?
#     puts cal.parse(File.read(ARGV[0]))
#   else
#     cal.run
#   end
# end


def shuffle_lines
  print "Input file name. "
  file_name = gets.chomp
  contents = File.readlines(file_name).shuffle

  File.open("#{file_name}-shuffled.txt", "w") do |f|
    f.puts contents
  end
  puts "Shuffled file located at #{file_name}-shuffled.txt"

end

shuffle_lines
