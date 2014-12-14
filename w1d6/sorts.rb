# bubble sort
# quick  sort
# merge  sort
# insert sort
# tim    sort

def bubble_sort(a)
  a = a.dup # for good measure
  (a.size-1).downto(0).each do |l| # the biggest elements bubble to the top
    (0...l).each do |i|            # so we can search one less per loop
      a[i], a[i+1] = a[i+1], a[i] if a[i] > a[i+1]
    end
  end
  a
end

def quick_sort(a)
  return a if a.size <= 1
  l, r, p = [], [], a.shift
  # I did this the other way
  a.each { |i| (i < p ? l : r) << i }
  quick_sort(l + [p]) + quick_sort(r)
end

def merge_sort(a)
  return a if a.size <= 1
  p = a.size / 2
  l, r, a = merge_sort(a[0...p]), merge_sort(a[p..-1]), []
  a << (l.first < r.first ? l : r ).shift until l.empty? || r.empty?
  a + l + r
end

def insert_sort(a)
  p a
  (a.size-1).times do |i|
    i.downto(0) do |p|
      if a[i] < a[p]
        a.insert(p-1, a.slice!(i))
        break
      end
    end
  end
  a
end

def tim_sort(a)
  # find runs in order
  # if they're in opposite order, reverse them
  # merge them
  # insert the rest
end
