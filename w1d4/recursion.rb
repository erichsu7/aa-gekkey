def range_rec(start, fin)
  return [] if start >= fin - 1
  return [start + 1] + range_rec(start + 1, fin)
end

def range_iter(start, fin)
  return [] if start > fin
  (start + 1).upto(fin - 1).to_a
end

def sum_rec(arr)
  return arr.first if arr.size == 1
  arr.first + sum_rec(arr[1..-1])
end

def sum_iter(arr)
  arr.inject(:+)
end

def exp_1(b, n)
  return 1 if n == 0
  b * exp_1(b, n - 1)
end

def exp_2(b, n)
  return 1 if n == 0
  if n.even?
    return exp_2(b, n / 2) ** 2
  else
    b * exp_2(b, n / 2) ** 2
  end
end

def deep_dup_cheat(arr)
  Marshal.load(Marshal.dump(arr))
end

class Array
  def deep_dup
    temp = []
    self.each do |el|
      if el.is_a?(Array)
        temp << el.deep_dup
      else
        temp << el
      end
    end
    temp
  end
end

def fib_rec(n)
  return [0, 1].take(n) if n <= 2
  temp = fib_rec(n - 1)
  temp + [temp[-2] + temp[-1]]
end

def fib_iter(n)
  a, b = 0, 1
  result = []
  n.times do
    result << a
    a, b = b, a + b
  end
  result
end

def bsearch(arr, target)
  median = arr.size / 2
  return median if arr[median] == target
  return nil if arr.size == 1
  if arr[median] < target
    offset = bsearch(arr[median..-1], target)
    return offset ? median + offset : nil
  else
    return bsearch(arr[0..(median - 1)], target)
  end
end

def make_change_cheating(amount, coins = [10, 7, 1])
  amount.times do |n|
    combs = coins.repeated_combination(n)
    combs = combs.zip(combs.map { |el| el.inject(:+) } )
    combs.each do |el, sum|
      return el if sum == amount
    end
  end
end


def make_change(amount, coins = [10, 7, 1])
  result = []
  (0...coins.size).each do |i|
    result << [0] * i + get_combo(amount, coins[i..-1])
  end
  optimal = result.sort { |el, el2| el.inject(:+) <=> el2.inject(:+) }.first
  (0...coins.size).each do |i|
    puts "#{optimal[i]} #{coins[i]}(s)"
  end
  nil
end

def get_combo(amount, coins = [10, 7, 1])
  return [] if coins.size == 0
  if amount >= coins.first && coins.size > 0
    return [amount / coins.first] + get_combo(amount % coins.first, coins[1..-1])
  else
    if coins.size > 0
      return [amount / coins.first] + get_combo(amount % coins.first, coins[1..-1])
    else
      [0]
    end
  end
end


def make_fuckin_change(amount, coins = [10, 7, 1])
  valid_coins = []
  coins.each do |coin|
    next if coin > amount
    valid_coins << [coin] + (amount - coin != 0 ? make_fuckin_change(amount - coin) : [])
  end
  valid_coins.sort { |a, b| a.length <=> b.length } .first
end


require "benchmark"
def test_speed(num)
  # time1 = Benchmark.measure do
  #   make_fuckin_change(num)
  # end
  # puts "Make fucking change:"
  # puts time1

  time2 = Benchmark.measure do
    make_change(num)
  end
  puts "Make Change: "
  puts time2
  # time3 = Benchmark.measure do
  #   make_change_cheating(num)
  # end
  # puts "Burtal Force! "
  # puts time3
end


def merge_sort(arr)
  return arr if arr.size <= 1
  median = arr.size / 2
  left = merge_sort(arr[0..(median - 1)])
  right = merge_sort(arr[(median)..-1])
  merge(left, right)
end


def merge(left, right)
  result = []
  while !left.empty? || !right.empty?
    if !left.empty? && !right.empty?
      if left.first <= right.first
        result.push(left.shift)
      else
        result.push(right.shift)
      end
    elsif left.empty?
      result.push(right.shift)
    elsif right.empty?
      result.push(left.shift)
    end
  end
  result
end


def subsets(arr)
  result = [[]]
  (0...arr.size).each do |len|
    (0...arr.size - len).each do |offset|
      result << arr[offset..offset+len]
    end
  end
  result
end

def subsets_rec(arr)
  return [[]] if arr.size == 0
  result = []
  last_el = arr.last
  subsets_rec(arr[0..-2]).each do |el|
    result << el
    result << el + [last_el]
  end
  result
end

def test_speed(num)
  time1 = Benchmark.measure do
    subsets(num)
  end
  puts time1

  time2 = Benchmark.measure do
    subsets_rec(num)
  end
  puts time2

end

p make_fuckin_change(14)
