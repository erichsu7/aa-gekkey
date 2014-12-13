class PolyTreeNode
  def initialize(value)
    @value = value
    @parent = nil
    @children = []
  end

  def parent
    @parent
  end

  def parent=(new_parent)
    # remove self from old parent's children
    @parent.children.delete(self) unless @parent.nil?

    # add self to new_parent's children
    unless new_parent.nil? || new_parent.children.include?(self)
      new_parent.children.push(self)
    end

    @parent = new_parent
  end

  def remove_child(node)
    node.parent=(nil)
    raise "#{node.value} is not a child" unless children.include? node
  end

  def children
    @children
  end

  def add_child(node)
    node.parent=(self)
  end

  def value
    @value
  end

  def dfs(target)
    return self if value == target
    children.each do |child|
      result = child.dfs(target)
      return result unless result.nil?
    end
    nil
  end

  def bfs(target)
    queue = [self]
    until queue.empty? || queue.first.value == target
      queue += queue.shift.children
    end
    queue.first
  end

  def trace_path_back(node)
    path = [node]
    return path if node.nil? || node == self
    trace_path_back(node.parent) + path
  end
end
