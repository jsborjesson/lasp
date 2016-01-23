require "lasp/eval"

require "lasp"
Lasp::load_stdlib!

describe "stdlib" do
  it "aliases" do
    expect(Lasp::execute("first")).to eq Lasp::CORELIB[:head]
    expect(Lasp::execute("rest")).to eq Lasp::CORELIB[:tail]
  end

  it "inc" do
    expect(Lasp::execute("(inc 5)")).to eq 6
  end

  it "dec" do
    expect(Lasp::execute("(dec 5)")).to eq 4
  end

  it "empty?" do
    expect(Lasp::execute("(empty? (list 1))")).to eq false
    expect(Lasp::execute("(empty? (list))")).to eq true
  end

  it "mod" do
    expect(Lasp::execute("(mod 133 51)")).to eq 31
  end

  it "complement" do
    expect(Lasp::execute("((complement empty?) (list 1))")).to eq true
  end

  it "even?" do
    expect(Lasp::execute("(even? 7)")).to eq false
    expect(Lasp::execute("(even? 4)")).to eq true
  end

  it "odd?" do
    expect(Lasp::execute("(odd? 7)")).to eq true
    expect(Lasp::execute("(odd? 4)")).to eq false
  end

  it "zero?" do
    expect(Lasp::execute("(zero? 0)")).to eq true
    expect(Lasp::execute("(zero? 1)")).to eq false
  end

  it "len" do
    expect(Lasp::execute("(len (list 1 2 3 4 5))")).to eq 5
  end

  it "nth" do
    expect(Lasp::execute("(nth 2 (list 0 1 2 3 4))")).to eq 2
  end

  it "last" do
    expect(Lasp::execute("(last (list 0 1 2 3 4))")).to eq 4
  end

  it "reverse" do
    expect(Lasp::execute("(reverse (list 1 2 3))")).to eq [3, 2, 1]
  end

  it "map" do
    expect(Lasp::execute("(map inc (list 1 2 3))")).to eq [2, 3, 4]
  end

  it "reduce" do
    expect(Lasp::execute("(reduce + 0 (list 1 2 3))")).to eq 6
    expect(Lasp::execute("(reduce * 1 (list 5 10))")).to eq 50
  end

  it "filter" do
    expect(Lasp::execute("(filter odd? (list 1 2 3))")).to eq [1, 3]
  end

  it "sum" do
    expect(Lasp::execute("(sum (list 5 10 15))")).to eq 30
  end

  it "take" do
    expect(Lasp::execute("(take 2 (list 1 2 3 4))")).to eq [1, 2]
  end

  it "drop" do
    expect(Lasp::execute("(drop 2 (list 1 2 3 4))")).to eq [3, 4]
  end

  it "range" do
    expect(Lasp::execute("(range 0 10)")).to eq (0...10).to_a
    expect(Lasp::execute("(range 10 0)")).to eq []
  end

  it "max" do
    expect(Lasp::execute("(max (list 4 6 1 5 3))")).to eq 6
  end

  it "min" do
    expect(Lasp::execute("(min (list 4 6 1 5 3))")).to eq 1
  end

  it "str->list" do
    expect(Lasp::execute('(str->list "abcdef")')).to eq %w[ a b c d e f ]
  end

  it "list->str" do
    expect(Lasp::execute("(list->str (list 1 2 3 4))")).to eq "1234"
  end

  it "->str" do
    expect(Lasp::execute("(->str 5)")).to eq "5"
  end

  it "pipe" do
    expect(Lasp::execute("(pipe 5 inc inc dec ->str)")).to eq "6"
  end

  it "reverse-str" do
    expect(Lasp::execute('(reverse-str "hello")')).to eq "olleh"
  end
end
