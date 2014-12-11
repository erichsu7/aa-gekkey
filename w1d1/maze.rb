class Maze
  def initialize file
    @maze = []
    file.each_line do |row|
      @maze << row.chomp.split('')
    end
  end

  # for printing
  def to_s
    @maze.each do |line|
      s = ''
    line.each do |char|
    char = 'S' if char == 0
    char = ' ' if char.is_a? Integer
    s += char
    end
    puts s
    end
  end

  def find_char char
    @maze.each_index do |y|
      x = @maze[y].index(char)
      return [x, y] unless x.nil?
    end
  end

  def adjacent(x, y) # [[x, y, @maze[y][x]] ... ]
    a = []
    d = [0, 1, -1] * 2
    d.repeated_permutation(2) do |mod_x, mod_y|
      a.push([x + mod_x, y + mod_y, @maze[y + mod_y][x + mod_x]])
    end
    return a
  end

  def calculate_paths
    #find starting space
    current_edge = [find_char('S')]
    next_edge = []

    #while End not found: find open spaces
    d = [0, 1, -1] * 2 # directions
    n = 0 # nth edge; distance from start
    end_found = false
    while !end_found do
        current_edge.each do |x, y|
          @maze[y][x] = n
          adjacent(x, y).each do |test_x, test_y, test_char|
          if test_char == ' '
            next_edge.push([test_x, test_y])
          elsif test_char == 'E'
            end_found = true
          end
        end
      end
      current_edge, next_edge = next_edge.uniq, []
      n += 1
    end
  end

  def shortest_path
    # find ending space
    x, y = find_char('E')

    # walk backwards, using smallest spaces
    while @maze[y][x] != 0
      @maze[y][x] = 'X' unless @maze[y][x] == 'E'
        x, y = ((adjacent(x, y).select {|a, b, c| (c.is_a?(Integer) && (a != 0 && b != 0))}).sort_by { |a, b, c| c })[0][0..1]
      break if @maze[y][x] == 0
    end
  end
end

maze = Maze.new(File.open(ARGV[0], 'r'))
maze.calculate_paths
maze.shortest_path
puts maze
