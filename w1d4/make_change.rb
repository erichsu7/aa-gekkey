def make_change(target, coins = [10, 7, 1])
  valid_coins = []
  coins.each do |coin|
    next if coin > target
<<<<<<< HEAD
    valid_coins << [coin] + (target - coin != 0 ? make_change(target - coin, coins) : [] )
=======
    valid_coins << [coin] + (target - coin != 0 ? make_change(target - coin) : [] )
>>>>>>> 615048553b036f7d4c3041473a0fe863b0a91d34
  end
  valid_coins.sort { |a, b| a.length <=> b.length } .first
end
