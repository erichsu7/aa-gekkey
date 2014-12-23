require "hanoi"

describe "Hanoi" do

  subject(:game) { Hanoi.new }

  it "initializes correctly" do
    expect(game.stacks).to eq([[5, 4, 3, 2, 1], [], []])
  end

  describe "#move" do

    it "can move disk on top of empty stack" do
      expect(game.move(0, 1)).to eq([[5, 4, 3, 2], [1], []])
    end

    it "can move disk onto smaller disk" do
      game.move(0, 2)
      game.move(0, 1)
      game.move(2, 1)
      expect(game.stacks).to eq([[5, 4, 3], [2, 1], []])
    end

    it "does nothing when attempting to move from empty stack" do
      expect(game.move(2, 1)).to eq([[5, 4, 3, 2, 1], [], []])
    end
    it "does nothing when attempting to move onto smaller disk"do
      game.move(0, 1)
      expect(game.move(0, 1)).to eq([[5, 4, 3, 2], [1], []])
    end
  end

  describe '#won?' do
    it 'returns true if a full stack has been moved' do
      game.stacks = [[], [5, 4, 3, 2, 1], []]
      expect(game.won?).to eq(true)
    end
    it 'returns false in every other case' do
      expect(game.won?).to eq(false)
      game.stacks = [[5, 4, 3], [2, 1], []]
      expect(game.won?).to eq(false)
    end
  end

  describe "#render" do

    it "prints stacks" do
      expect { game.render }.to output("1    \n2    \n3    \n4    \n5    \n").to_stdout
      game.stacks = [[4, 3], [2, 1], [5]]
      expect { game.render }.to output("3 1  \n4 2 5\n").to_stdout
    end

  end

end
