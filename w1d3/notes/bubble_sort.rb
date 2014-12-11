class Array
  def bubble_sort!
    sorted = false
    until sorted
      sorted = true
      (0...self.length - 1).each do |i|
        if self[i] > self[i + 1]
          self[i], self[i + 1] = self[i + 1], self[i]
          sorted = false
        end
      end
    end
    self
  end
end

a = [1, 2, 3, 4, 2, 1, 3]
a.bubble_sort! # => [1, 1, 2, 2, 3, 3, 4]
