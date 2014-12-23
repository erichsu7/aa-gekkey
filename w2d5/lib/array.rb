class Array

  def my_uniq
    found_elements = []
    self.each do |elt|
      found_elements << elt unless found_elements.include?(elt)
    end
    found_elements
  end


  def two_sum
    sums = []
    self.each_index do |i|
      (i + 1...self.length).each do |j|
        sums << [i, j] if self[i] + self[j] == 0
      end
    end
    sums
  end

  def my_transpose
    temp = Array.new(self.size) { Array.new }

    self.each_with_index do |row, i|
      row.each_with_index do |col, j|
        temp[j][i] = self[i][j]
      end
    end

    temp
  end
end

def stock_picker(arr)
  most_profit, pair = 0, []

  arr.each_with_index do |buy, i|
    ((i + 1)...arr.size).each do |j|
      if arr[j] - buy > most_profit
        most_profit = arr[j] - buy
        pair = [i, j]
      end
    end
  end

  pair
end
