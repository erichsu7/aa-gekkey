require 'set'

class Map
  def initialize(set)
    @store = set.to_a.map { |word| [word, [[], nil]] } .to_h
  end

  def optimize_for!(word)
    toss_wrong_sized_words(word.size)
    true
  end

  def prune!
    @store.each do |k, v|
      @store.delete(k) if v[1].nil?
    end
  end

  def deep_copy
    new_dict = self.class.new({})
    self.each do |k, v|
      new_dict[k] = []
      new_dict[k] << self[k][0].dup
      new_dict[k] << self[k][1]
    end
    new_dict
  end

  def [](x)
    @store[x]
  end

  def []=(x, y)
    @store[x] = y
  end

  def include? key
    @store.has_key? key
  end

  def keys
    @store.keys
  end

  def each &block
    @store.each &block
  end

  def select &block
    @store.select &block
  end

  private

  def toss_wrong_sized_words(size)
    @store = @store.select { |el| el.length == size }
  end
end

class WordChain
  def initialize(file_name)
    # dictionary = {"word" => { :adjacent => ["words"], :distance => nil }}
    @dictionary = Set.new.merge(File.readlines(file_name).map(&:chomp))
  end

  def map_path(start_word, end_word)
    gen_map(start_word, end_word) unless @map.has_key?(start_word)
    return "no path found" unless @map[start_word].include?(end_word)
    gen_path(start_word, end_word)
  end

  def gen_map(word, end_word)
    @map = Map.new(@dictionary)
    @map.optimize_for!(word)
    @map[word][0] = adjacent_words(word)
    @map[word][1] = 0

    mapped = Set.new
    map_next = map[word][0]
    n = 1

    until mapped.include? end_word
      map_next.each do |el|
        next if mapped.include? el

        adjacent = adjacent_words(el)
        @map[el][0] += adjacent
        map_next += adjacent
        @map[el][1] = (@map[el][1] && @map[el][1] <= n) ? @map[el][1] : n
        mapped.add el
      end
      n += 1
    end

    @map.prune!
  end

  def gen_path(start_word, end_word)
    chain = [end_word]
    while end_word != start_word
      closest, closest_word = @map[start_word][end_word][1], end_word
      @map[start_word][end_word][0].each do |next_word|
        if @map[start_word][next_word][1] < closest
          closest = @map[start_word][next_word][1]
          closest_word = next_word
        end
      end
      end_word = closest_word
      chain << end_word
    end
    chain.reverse
  end

  private

  def adjacent_words(word)
    result = []

    word.split('').each_with_index do |char, i|
      ('a'..'z').each do |n_char|
        next if char == n_char
        test_word = word.dup
        test_word[i] = n_char
        if @dictionary.include? test_word
          result << test_word
        end
      end
    end
    result
  end

end

wc = WordChain.new("./wordsEn.txt")
puts wc.map_path('cold', 'warm')
