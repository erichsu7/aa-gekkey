def sym_string(string)
  all_subs = []
  (2..string.length).each do |subs|
    (0..string.length-subs) do |pos|
      all_subs << string[pos, subs]
    end
  end
  all_subs.select{ |sub| sub == sub.reverse }
end
