require "lasp"

describe "language features" do
  it "treats lists as functions of their cotents" do
    expect(Lasp::execute('((list 1 2 3) 2)')).to eq 3
  end

  it "treats dicts as functions of their cotents" do
    expect(Lasp::execute('((dict :seven 7 :four 4) :seven)')).to eq 7
  end
end
