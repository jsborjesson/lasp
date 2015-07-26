require "./lib/eval"

Lasp::execute_file(File.expand_path("./lib/stdlib.lasp"))

describe "stdlib" do
  it "inc" do
    expect(Lasp::execute("(inc 5)")).to eq 6
  end

  it "len" do
    expect(Lasp::execute("(len (list 1 2 3 4 5))")).to eq 5
  end
end
