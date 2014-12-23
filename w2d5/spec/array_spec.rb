require "array"

describe "#my_uniq" do
  it "returns an empty array when given an empty array" do
    expect([].my_uniq).to eq([])
  end

  it "returns the same array when there are no duplicates" do
    expect([1, 2, 3].my_uniq).to eq([1, 2, 3])
  end

  it "returns the uniqe elements in order" do
    expect([1, 2, 1, 3, 3].my_uniq).to eq([1, 2, 3])
  end

end

describe "#two_sum" do

  it "returns an empty array when given an empty array" do
    expect([].two_sum).to eq([])
  end

  it "returns an empty array when there are no sums" do
    expect([1, 2].two_sum).to eq([])
  end

  it "returns one pair of sum indices" do
    expect([-1, 1].two_sum).to eq([[0, 1]])
  end

  it "returns multiple pairs of sum indices" do
    expect([-1, 0, 2, -2, 1].two_sum).to eq([[0, 4], [2, 3]])
  end
end

describe "#my_transpose" do
  it "actually works" do
    rows = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8]
    ]
    cols = [
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8]
    ]
    expect(rows.my_transpose).to eq(cols)
  end
  it "doesn't modify original array" do
    rows = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8]
    ]
    rows.my_transpose
    dup = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8]
    ]
    expect(rows).to eq(dup)
  end
end

describe "#stock_picker" do
  it "returns the most profitable pair of days" do
    expect(stock_picker([1, 4, 2, 7, 4])).to eq([0, 3])
  end
  it "does not violate causality" do
    expect(stock_picker([8, 4, 5, 7, 3])).to eq([1, 3])
  end
  it "returns empty array if no profitable days" do
    expect(stock_picker([8, 6, 4, 2, 1])).to eq([])
  end

end
