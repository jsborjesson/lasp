require "./lib/eval"

Lasp::execute_file(File.expand_path("./lib/stdlib.lasp"))

describe "stdlib" do
  it "has aliases" do
    expect(Lasp::execute("first")).to eq Lasp::CORELIB[:head]
    expect(Lasp::execute("rest")).to eq Lasp::CORELIB[:tail]
  end

  it "inc" do
    expect(Lasp::execute("(inc 5)")).to eq 6
  end

  it "empty?" do
    expect(Lasp::execute("(empty? (list 1))")).to eq false
    expect(Lasp::execute("(empty? (list))")).to eq true
  end

  it "len" do
    expect(Lasp::execute("(len (list 1 2 3 4 5))")).to eq 5
  end

  it "nth" do
    expect(Lasp::execute("(nth 2 (list 0 1 2 3 4))")).to eq 2
  end

  it "map" do
    expect(Lasp::execute("(map inc (list 1 2 3))")).to eq [2, 3, 4]
  end

  it "reduce" do
    expect(Lasp::execute("(reduce + 0 (list 1 2 3))")).to eq 6
    expect(Lasp::execute("(reduce * 1 (list 5 10))")).to eq 50
  end

  it "sum" do
    expect(Lasp::execute("(sum (list 5 10 15))")).to eq 30
  end
end
