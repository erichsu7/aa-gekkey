class Hanoi

  attr_accessor :stacks

  def initialize
    @stacks = [[5, 4, 3, 2, 1], [], []]
  end

  def move(move_from, move_to)
    return stacks if stacks[move_from].empty?
    return stacks if stacks[move_to].last && stacks[move_from].last > stacks[move_to].last
    stacks[move_to] << stacks[move_from].pop
    stacks
  end

  def won?
    stacks[1] == [5, 4, 3, 2, 1] || stacks[2] == [5, 4, 3, 2, 1]
  end

  def render
    s = ""
    (@stacks.map { |e| e.size } .max).times.to_a.reverse.each do |i|
      3.times do |j|
        s += (@stacks[j][i].nil? ? ' ' : @stacks[j][i].to_s) + ' '
      end
      s = s[0...-1] + "\n"
    end
    print s
  end
end
