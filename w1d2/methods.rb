def rps(player_choice)
  possible_combinations = {
    ['Rock', 'Paper'] => 'Lose',
    ['Paper', 'Scissors'] => 'Lose',
    ['Scissors', 'Rock'] => 'Lose'
  }
  possible_combinations.keys.each do |combination|
    possible_combinations[combination.reverse] = 'Win'
  end

  possible_choices = ['Rock', 'Paper', 'Scissors']
  ai_choice = possible_choices.sample
  if player_choice == ai_choice
    result = 'Draw'
  else
    result = possible_combinations[[player_choice, ai_choice]]
  end

  "#{ai_choice}, #{result}"
end

# p rps("Rock")
# p rps("Scissors")
# p rps("Scissors")


def remix(ingredients)
  alchohols, mixers = [], []
  ingredients.each do |a, b|
    alchohols << a
    mixers << b
  end
  alchohols, mixers = alchohols.shuffle, mixers.shuffle
  alchohols.zip(mixers)
end

def brief_remix(i)
  a, b = i.transpose
  a.shuffle.zip(b.shuffle)
end

# p brief_remix([
#   ["rum", "coke"],
#   ["gin", "tonic"],
#   ["scotch", "soda"]
#   ])
