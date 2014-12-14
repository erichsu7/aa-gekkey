# a node contains a list of adjacent nodes' index, and distance from the start
# a nodemap is a hash of nodes
# a wordnode is a node with the ability for find adjacent nodes
# a wordmap is a nodemap of words in a dictionary
# a wordchain generates a wordmap from a start_word to an end_word, then traces back

require 'set'

class Node
  attr_accessor :index, :adjacent, :depth
  def initialize(index, adjacent = [], depth = nil)
    @index, @adjacent, @depth = index, adjacent, depth
  end
end

class NodeMap
  def initialize hash = Hash.new
    @store = hash
  end

  def prune! &block
    @store.each do |k, v|
      @store.delete k  if block.call(k, v)
    end
  end

  def [] x
    @store[x]
  end

  def include? key
    @store.has_key? key
  end
end

class WordNode < Node
  def initialize(map, *args)
    @map = map
    super(*args)
  end

  def adjacent
    return @adjacent if @adjacent != []
    # return the cached result if it has been generated
    # otherwise generate and cache, then return, the result

    result = []
    index.chars.each_with_index do |char, i|
      ('a'..'z').each do |new_char|
        next if char == new_char
        test_word = @index.dup
        test_word[i] = new_char
        result << test_word if @map.include? test_word
      end
    end
    @adjacent = result
  end

  def closest
    i, n = nil, @depth
    adjacent.each do |other_node|
      if @map[other_node].depth && @map[other_node].depth < n
        n = @map[other_node].depth
        i = other_node
      end
    end
    i
  end
end

class WordMap < NodeMap
  def initialize set
    @dictionary = set
    super(set.to_a.map { |word| [word, WordNode.new(self, word)]} .to_h)
  end

  def set_start_word(word)
    @store = @store.select { |el| el.length == size } # delete words of the wrong length
  end

  def dictionary
    @dictionary
  end
end

class WordChain
  attr_accessor :map
  def initialize(file)
    @dict = Set.new.merge(File.readlines(file).map(&:chomp))
    @map = WordMap.new(@dict)
  end

  def run(*args)
    map_depth(*args)
    make_chain(*args)
  end

  private

  def map_depth(start_word, end_word)
    next_words = [start_word]
    words_seen = Set.new
    depth = 0

    until words_seen.include? end_word
      next_words.each do |current_word|
        next if words_seen.include? current_word
        words_seen.add(current_word)
        next_words += @map[current_word].adjacent
        @map[current_word].depth = depth
      end
      depth += 1
    end
    depth
  end

  def make_chain(start_word, end_word)
    chain = [end_word]
    until start_word == end_word
      chain.unshift @map[end_word].closest
      end_word = chain.first
    end
    chain
  end
end

wc = WordChain.new("./wordsEn.txt")
puts wc.run('duck', 'ruby')
puts wc.run('stone', 'money')
