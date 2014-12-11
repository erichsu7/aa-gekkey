class Code
  VALID_COLORS = ['R', 'G', 'B', 'Y', 'O', 'P']
  VALID_COMBS  = VALID_COLORS
    .repeated_combination(4)
    .to_a
    .map { |el| el.join('')}

  attr_reader :store

  def self.random
    # arr = []
    # 4.times do
    #   arr << VALID_COLORS.sample
    # end
    # arr
    self.new(VALID_COMBS.sample)
  end

  # def self.parse(input)
  #   self.new(input)
  # end

  def initialize(value)
    @store = value
  end

  def matches(other_code)
    found = {}
    other_code = other_code.store.split('')

    found[:exact], other_code = _exact_matches(other_code)
    found[:near] = _near_matches(other_code)
    found
  end

  def _exact_matches(other_code)
    found = 0
    code = store.split('')

    code.each_with_index do |char, index|
      if char == other_code[index]
        found += 1

        other_code[index] = ' '
      end
    end
    [found, other_code]
  end

  def _near_matches(other_code)
    found = 0
    code = store.split('')

    code.each_with_index do |char, index|
      if other_code.include?(char)
        found += 1

        other_code[other_code.index(char)] = ' '# other_code.delete(char)
      end
    end
    found
  end
end

class Game
  def play(turns)
    ai = Code.random
    turns.times do |turn|
      print "guess four colors: "
      player = Code.new(gets.chomp.upcase)
      matches = ai.matches(player)
      if matches[:exact] == 4
        puts "You guessed correctly in #{turn + 1} turns"
        break
      end

      puts "You have #{matches[:exact]} exact matches and #{matches[:near]} near matches"
      puts "You have LOST. The correct answer is #{ai.store}" if turn == turns - 1

    end
  end
end

# 10.times do
#   p Code.random
# end

game = Game.new
game.play(5)
