def make_change(target, coins = [10, 7, 1])
  valid_coins = []
  coins.each do |coin|
    next if coin > target
    valid_coins << [coin] + (target - coin != 0 ? make_change(target - coin) : [] )
  end
  valid_coins.sort { |a, b| a.length <=> b.length } .first
end
