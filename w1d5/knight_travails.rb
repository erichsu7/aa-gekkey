require './00_tree_node'

class KnightPathFinder

  def self.valid_moves(pos)
    # here be linear algebra !
    base_moves = [[1] * 4, [2] * 4]
    base_moves = base_moves.transpose + base_moves.reverse.transpose
    modifier = [1, -1].repeated_permutation(2).to_a * 2
    moves = base_moves.each_with_index.map do |v, i|
      [pos[0] + v[0] * modifier[i][0], pos[1] + v[1] * modifier[i][1]]
    end
    moves.select { |x, y| (0..7).include?(x) && (0..7).include?(y) }
  end

  attr_reader :tree

  def initialize(start_pos)
    @start_pos = start_pos
    @tree = PolyTreeNode.new(start_pos)
  end

  def build_move_tree
    visited_positions = [@start_pos]
    queue = [@start_pos]
    until queue.empty?
      current_position = queue.shift
      node_of_current_pos = @tree.dfs(current_position)
      self.class.valid_moves(current_position).each do |move|
        next if visited_positions.include?(move)
        new_node = PolyTreeNode.new(move)
        new_node.parent = node_of_current_pos
        queue << move
        visited_positions << move
      end
    end
  end

  def find_path(end_pos)
    node_at_end_pos = @tree.bfs(end_pos)
    @tree.trace_path_back(node_at_end_pos)
  end
end

kpf = KnightPathFinder.new([0, 0])
kpf.build_move_tree
p kpf.find_path([7, 6]).map { |node| node.value }
