require_relative 'tic_tac_toe'

class TicTacToeNode
  attr_accessor :board, :next_mover_mark, :prev_move_pos
  def initialize(board, next_mover_mark, prev_move_pos = nil)
    @board, @next_mover_mark, @prev_move_pos =
      board, next_mover_mark, prev_move_pos
  end

  def losing_node?(evaluator)
    return (@board.winner && @board.winner != evaluator) if @board.over?

    if evaluator == next_mover_mark
      return true if children.all? { |child| child.losing_node?(evaluator) }
    else
      return true if children.any? { |child| child.losing_node?(evaluator) }
    end
    false
  end

  def winning_node?(evaluator)
    return (@board.winner && @board.winner == evaluator) if @board.over?

    if evaluator == next_mover_mark
      return true if children.any? { |child| child.winning_node?(evaluator) }
    else
      return true if children.all? { |child| child.winning_node?(evaluator) }
    end
    false
  end

  # This method generates an array of all moves that can be made after
  # the current move.
  def children
    possible_nodes = []
    3.times do |x|
      3.times do |y|
        if @board.empty?([x, y])
          new_board = @board.dup
          new_board[[x, y]] = @next_mover_mark
          new_mover_mark = (@next_mover_mark == :x ? :o : :x)
          possible_nodes << TicTacToeNode.new(new_board, new_mover_mark, [x, y])
        end
        #call on losing_node? or winning_node? to figure out if this is our move
      end
    end
    possible_nodes
  end
end
