def factors(number)
  all_factors = []
  i = 1
  while i <= (number / 2)
    all_factors << i if number % i == 0

    i += 1
  end
  all_factors
end

# p factors(30)

class Array

  def bubble_sort
    repeat = true
    while repeat
      repeat = false
      (self.length-1).times do |i|
        if self[i] > self[i+1]
          self[i], self[i+1] = self[i+1], self[i]
          repeat = true
          break
        end

      end

    end

    self
  end

end
# p [5,4,3,2,1].bubble_sort


def substrings(string)
  dict = File.readlines('dictionary.txt').map { |line| line.chomp }

  all_substrings = []
  (0...string.length).each do |i|
    (i...string.length).each do |j|
      all_substrings << string[i..j] if dict.include? string[i..j]
    end
  end

  all_substrings
end

p substrings("cat")
