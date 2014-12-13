class Game
  def initialize(*players)
    @players = players
  end

  def recieve_secret_length(length)
    @word = Array.new(length, '_')
  end

  def merge(letters)
    # puts "merging #{@word} with #{letters}"
    @word.each_index do |i|
      @word[i] = letters[i] if letters[i] != '_'
    end
    @word
  end

  def play
    # ask player[0] for word length
    length = @players[0].pick_secret_word
    recieve_secret_length(length)
    @players[1].recieve_secret_length(length)

    while @word.include? '_'
      guess = @players[1].guess
      response = @players[0].check_guess(guess)
      new_word = merge(response)
      puts new_word * ''
      @players[1].handle_guess_response(new_word)
    end
  end
end

class HumanPlayer
  def guess
    print '>> '
    gets[0]
  end

  def pick_secret_word
    print "word length >> "
    @length = gets.to_i
  end

  def recieve_secret_length(length)
    puts '_' * length
  end

  def check_guess(letter)
    print "#{letter}? >> "
    response = gets.chomp.gsub(' ', '_')[0...@length]
    response += '_' * (@length - response.length)
  end

  def handle_guess_response(word)
    puts "#{word * ''}"
  end
end

class ComputerPlayer
  DICT = File.readlines("dictionary.txt").map { |line| line.chomp }

  def initialize
    @guessed = []
  end

  def pick_secret_word
    @word = DICT.sample
    @word.length
  end

  def recieve_secret_length(length)
    @dictionary = DICT.select { |el| el.length == length }
  end

  def guess()
    local_freq = Hash.new(0)
    @dictionary.each do |word|
      word.split('').each do |char|
        local_freq[char] += 1
      end
    end
    local_freq = local_freq.sort_by { |k, v| v } .map { |k, v| k }
    
    current_guess = (local_freq - @guessed).last
    @guessed << current_guess
    current_guess
  end

  def check_guess(letter)
    correct_letters = ''
    @word.split('').each_index do |i|
      correct_letters += @word[i] == letter ? letter : '_'
    end
    correct_letters
  end

  def handle_guess_response(guess_word)
    new_dictionary = @dictionary.dup
    guess_word.each_with_index do |position, i|
      next if position == '_'
      @dictionary.each do |word|
        new_dictionary.delete(word) if word.split("")[i] != position
      end
    end
    @dictionary = new_dictionary
  end
end

hangman = Game.new(ComputerPlayer.new, ComputerPlayer.new)
hangman.play
