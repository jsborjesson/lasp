require "lasp/representation"

describe "representation" do
  it "shows lists with parentheses and no commas" do
    expect([1, 2, 3].inspect).to eq "(1 2 3)"
  end

  it "shows symbols without colons" do
    expect(:fn.inspect).to eq "fn"
  end

  it "shows nested lists correctly" do
    expect([:fn, [1, 2, [:num, "three"]]].inspect).to eq '(fn (1 2 (num "three")))'
  end

  it "shows hashes without the hash-rockets" do
    expect({"one"=>1, "two"=>2}.inspect).to eq '{"one" 1, "two" 2}'
  end
end
