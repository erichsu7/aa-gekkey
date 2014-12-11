class Array
  def my_uniq
    temp = []
    self.each do |i|
      temp << i unless temp.include? i
    end
    temp
  end

  def two_sum
    self.length.times.to_a.combination(2).select { |a, b| self[a] + self[b] == 0 }
  end
end

# p [-1, 0, 2, -2, 1].two_sum

class ToH
  def initialize n
    @size = n
    @pile = { 1 => (1..n).to_a.reverse }
    @pile[2] = []
    @pile[3] = []
  end

  def run
    loop do
      print_towers
      print 'Enter move: '
      command = gets.chomp.split(' ').map { |i| i.to_i }
      move command[0], command[1]
      if won?
        puts "You won!"
        break
      end
    end
  end

  def move a, b
    if @pile[a].empty?
      puts "There is nothing there."
    elsif !@pile[b].empty? && @pile[a].last > @pile[b].last
      puts "You can't put a disk on a smaller one!"
    else
      @pile[b].push(@pile[a].pop)
    end
  end

  def print_towers
    (0...@size).to_a.reverse.each do |i|
      puts "#{@pile[1][i] || '|'} #{@pile[2][i] || '|'} #{@pile[3][i] || '|'}"
    end
  end

  def won?
    return true if @pile[2].length == @size || @pile[3].length == @size
    return false
  end
end

def my_transpose array
  temp = []
  array.length.times do
    temp.push([])
  end

  array.each do |row|
    row.each_with_index do |v, i| #index, value
      temp[i].push(v)
    end
  end
  temp
end

def stock_picker array
  max = 0
  days = []
  (0...array.length - 1).each do |x|
    (x + 1...array.length).each do |y|
      if array[y] - array[x] > max
        days = [x, y]
        max = array[y] - array[x]
      end
    end
  end
  days
end

def num_to_s num, base
  num_str = ''
  chars = ('0'..'9').to_a + ('A'..'Z').to_a

  while num > 0
    num_str = chars[num % base] + num_str
    num /= base
  end

  num_str
end

def caesar str, shift
  out_str = ""
  str.each_byte do |c| # char
    c += shift
    c =- 26 if c > 'z'.ord
    out_str += c.chr
  end
  out_str
end

class MyHashSet
  attr_accessor :store

  def initialize keys=[]
    @store = {}
    keys.each do |key|
      @store[key] = true
    end
  end

  def insert el
    @store[el] = true
  end

  def include? el
    @store.has_key? el
  end

  def delete el
    @store.delete(el) || false
  end

  def union set
    self.class.new(@store.merge(set.store).keys)
  end

  def intersect set2
    new_set = self.class.new
    @store.keys.each do |el|
      new_set.store[el] = true if set2.include? el
    end
    new_set
  end

  def minus set2
    new_set = self.class.new
    @store.keys.each do |el|
      new_set.store[el] = true unless set2.include? el
    end
    new_set
  end

  def inspect
    @store.keys
  end

end

# set1 = MyHashSet.new([1,2,3])
# set1.insert(0)
# set1.insert(2)
# p set1
# p set1.include? 3
# set2 = MyHashSet.new([2,3,4,5])
# set2.insert(2)
# set2.insert(3)
# set2.insert(4)
# set2.insert(5)
# p set2.include? 1
# p set2.delete 2
# p set2.delete 2
# p set2
# p set1.union(set2)
# p set1.intersect(set2)
# p set1.minus(set2)

def double_all array
  array.map { |i| i*2 }
end

class Array
  def my_each
    for i in 0...self.length
      yield self[i]
    end
    self
  end

  def median
    return self.sort[self.length / 2] if self.length.odd?
    (self.sort[self.length / 2] + self.sort[self.length / 2 - 1]).to_f / 2
  end
end

def concatenate array
  array.inject(:+)
end
# return_value = [1, 2, 3].my_each { |num| puts num }.my_each do |num|
#   puts num
# end
# #   =>  1
# #       2
# #       3
# #       1
# #       2
# #       3
#
# p return_value # => [1, 2, 3]

# p (1..7).to_a.median
# p (1..8).to_a.median

# p concatenate(["Yay ", "for ", "strings!"])
