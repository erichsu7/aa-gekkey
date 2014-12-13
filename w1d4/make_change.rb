def make_change(amount, coins = [10, 7, 1])
  valid_coins = []
  coins.each do |coin|
    next if coin > amount
    valid_coins << [coin] + (amount - coin != 0 ? make_change(amount - coin) : [] )
  end
  valid_coins.sort { |a, b| a.length <=> b.length } .first
end

p make_change(14)
