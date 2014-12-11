class Integer
  def in_words
    return 'zero' if self == 0
    words = {1 => 'one',
             2 => 'two',
             3 => 'three',
             4 => 'four',
             5 => 'five',
             6 => 'six',
             7 => 'seven',
             8 => 'eight',
             9 => 'nine',
             10 => 'ten',
             11 => 'eleven',
             12 => 'twelve',
             13 => 'thirteen',
             14 => 'fourteen',
             15 => 'fifteen',
             16 => 'sixteen',
             17 => 'seventeen',
             18 => 'eighteen',
             19 => 'nineteen',
             20 => 'twenty',
             30 => 'thirty',
             40 => 'forty',
             50 => 'fifty',
             60 => 'sixty',
             70 => 'seventy',
             80 => 'eighty',
             90 => 'ninety',
             100 => 'hundred',
             1000 => 'thousand',
             1_000_000 => 'million',
             1_000_000_000 => 'billion',
             1_000_000_000_000 => 'trillion'}
    order = words.keys.sort_by { |k| -k } # an array, starting with the largest key
    x = self
    s = ''
    order.each do |i|
      next if i > x
      if x >= 100
        s += ' ' + (x / i).in_words + ' ' + words[i]
        x %= i
      else
        s += ' ' + words[i]
        x -= i
      end
    end
    s[1..-1]
  end
end
