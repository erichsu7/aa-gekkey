class Array
  def my_each
    self.length.times { |el| yield(self[el]) }
  end

  def my_map
    result = []
    self.my_each { |el| result << yield(el) }
    result
  end

  def my_select
    result = []
    self.my_each { |el| result << el if yield(el) }
    result
  end

  def my_inject
    sum = self[0]
    self[1..-1].my_each do |el|
      sum = yield(sum, el)
    end
    sum
  end

  def my_sort!
    sorted = false
    until sorted
      sorted = true
      0.upto(self.length - 2).each do |i|
        if yield(self[i], self[i + 1]) == 1
          self[i], self[i + 1] = self[i + 1], self[i]
          sorted = false
        end
      end
    end
  end

  def my_sort(&sort_proc)
    copy = self.dup
    copy.my_sort!(&sort_proc)
    copy
  end

end

def eval_block(*arg, &my_block)
  return "NO BLOCK GIVEN" unless block_given?
  my_block.call(*arg)
end
