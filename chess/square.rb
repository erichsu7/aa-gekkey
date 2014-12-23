require 'set'

class Square
  #initialize
  def initialize(piece = nil)
    @piece = piece
    @colored = {black: Set.new, white: Set.new}
    @lords, @colored = Hash.new, {white: {}, black: {}}
    @protecting = Hash.new
  end

  # readers
  def lords(color = :both)
    if color == :both
      @lords
    else
      @colored[color]
    end
  end

  def piece
    @piece
  end

  def guards
    @protecting
  end

  def render
    if @piece.nil?
      '  '
    else
      @piece.symbol + ' '
    end
  end

  def inspect
    s = "\n"
    if @piece
      s += "#{@piece.color} #{@piece.class} at #{@piece.pos}"
    else
      s += "empty space"
    end
    s += " threatened by:\n"

    @lords.each do |lord, dir|
      s += "\t #{lord.class} at #{lord.pos}\n"
    end

    s += "protected by:\n"

    @protecting.each do |guard, dir|
      s += "\t #{guard.class} at #{guard.pos}\n"
    end
    s
  end

  # writers
  def place(other_piece)
    @piece = other_piece
    self
  end

  def remove(other_piece)
    @piece = nil
    other_piece
  end

  def subject(other_piece, direction)
    @lords[other_piece] = direction
    @colored[other_piece.color][other_piece] = direction
  end

  def relieve(other_piece)
    @lords.delete(other_piece)
    @colored[other_piece.color].delete(other_piece)
  end

  def guard(protector, threat, dir)
    @protecting[protector] = [threat, dir]
  end

  def unguard(other_piece)
    @protecting.delete(other_piece)
  end
end
