require 'set'

class Node
  attr_accessor :parent, :adjacent
  def initialize(parent = nil, adjacent = [])
    @parent, @adjacent = parent, adjacent
  end
end

class NopeMap
  # a hash of node objects
  def initialize(set)
    @store = set.to_a.map { |object| [object, Node.new]} .to_h
  end

  def prune! (&blk)
    @store.each do |k, v|
      @store.delete(k) if blk.call(k, v)
    end
  end

  def deep_copy
    new_dict = self.class.new(Set.new)
    self.each do |k, v|
      new_dict[k] = self[k].dup
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
end

class WordMap < NopeMap
  # a nodemap, with each node a string
  def set_start_word(word)
    self.optimize_for!(word)
    self[word].adjacent = adjacent_words(word)
  end

  def map_adjacent(word, depth)
    self[word].adjacent = adjacent_words(word).each do |other_word|
    self[word].parent = depth if self[word].parent && self[word].parent < depth
    end.to_a
  end

  def closest_word(word)
    raise "#{word} not indexed" if self[word].nil?
    self[word].parent
  end

  def optimize_for!(word)
    toss_wrong_sized_words(word.size) && true
  end

  private

  def toss_wrong_sized_words(size)
    @store = @store.select { |el| el.length == size }
  end

  def adjacent_words(word)
    result = []

    word.split('').each_with_index do |char, i|
      ('a'..'z').each do |n_char|
        next if char == n_char
        test_word = word.dup
        test_word[i] = n_char
        if self.include? test_word
          result << test_word
        end
      end
    end
    result
  end
end

class WordChain
  def initialize(file_name)
    # dictionary = {"word" => { :adjacent => ["words"], :distance => nil }}
    @dictionary = Set.new.merge(File.readlines(file_name).map(&:chomp))
  end

  def map_path(start_word, end_word)
    @map = WordMap.new(@dictionary)
    @map.optimize_for!(start_word)
    @map.set_start_word(start_word)

    gen_map(start_word, end_word)
    return "no path found" unless @map.include?(end_word)
    gen_path(start_word, end_word)
  end

  def gen_map(word, end_word)
    mapped = Set.new
    mapped.add(word)
    queue = @map[word].adjacent
    n = 0

    until mapped.include? end_word
      next_queue = []
      queue.each do |el|
        next if mapped.include? el
        next_queue += @map.map_adjacent(el, n).reject { |x| mapped.include?(x) }
        mapped.add el
      end
      queue = next_queue
      n += 1
    end

    @map.prune! { |k, v| v.adjacent == [] }
  end

  def gen_path(start_word, end_word)
    chain = [end_word]
    until end_word.nil?
      chain = [@map.closest_word(end_word)] + chain
      end_word = chain.first
    end
    chain
  end
end

wc = WordChain.new("./wordsEn.txt")
puts wc.map_path('duck', 'ruby')
