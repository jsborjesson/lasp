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

  it "len" do
    expect(Lasp::execute("(len (list 1 2 3 4 5))")).to eq 5
  end

  it "nth" do
    expect(Lasp::execute("(nth 2 (list 0 1 2 3 4))")).to eq 2
  end

  it "map" do
    expect(Lasp::execute("(map inc (list 1 2 3))")).to eq [2, 3, 4]
  end
end
