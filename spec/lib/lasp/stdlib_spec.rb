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

  it "nil?" do
    expect(Lasp::execute("(nil? (list))")).to eq false
    expect(Lasp::execute("(nil? false)")).to eq false
    expect(Lasp::execute("(nil? nil)")).to eq true
  end

  it "empty?" do
    expect(Lasp::execute("(empty? (list 1))")).to eq false
    expect(Lasp::execute("(empty? (list))")).to eq true
  end

  it "not=" do
    expect(Lasp::execute("(not= 2 2 3)")).to eq true
    expect(Lasp::execute("(not= 2 2 2)")).to eq false
  end

  it "second" do
    expect(Lasp::execute("(second (list 1 2 3))")).to eq 2
    expect(Lasp::execute("(second (list 1))")).to eq nil
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

  it "every" do
    expect(Lasp::execute('(every 2 (list 1 2 3 4 5))')).to eq [1, 3, 5]
    expect(Lasp::execute('(every 3 (list 1 2 3 4 5))')).to eq [1, 4]
  end

  it "text" do
    expect(Lasp::execute('(text "one " 1 ", two " 2)')).to eq "one 1, two 2"
  end

  it "text->list" do
    expect(Lasp::execute('(text->list "abcdef")')).to eq %w[ a b c d e f ]
  end

  it "list->text" do
    expect(Lasp::execute("(list->text (list 1 2 3 4))")).to eq "1234"
  end

  it "->text" do
    expect(Lasp::execute("(->text 5)")).to eq "5"
  end

  it "->integer" do
    expect(Lasp::execute("(->integer :5)")).to eq 5
  end

  it "->decimal" do
    expect(Lasp::execute('(->decimal "5.5")')).to eq 5.5
  end

  it "pipe" do
    expect(Lasp::execute("(pipe 5 inc inc dec ->text)")).to eq "6"
  end

  it "reverse-text" do
    expect(Lasp::execute('(reverse-text "hello")')).to eq "olleh"
  end

  it "prompt" do
    expect(STDOUT).to receive(:print).with("Question: ")
    allow(STDIN).to receive(:gets).and_return("answer\n")

    expect(Lasp::execute('(prompt "Question: ")')).to eq "answer"
  end

  describe "println" do
    it "prints its argument with a newline" do
      expect(STDOUT).to receive(:print).with("test\n")
      Lasp::execute('(println "test")')
    end

    it "prints several arguments on a line" do
      expect(STDOUT).to receive(:print).with("onetwothree\n")
      Lasp::execute('(println :one :two :three)')
    end

    it "prints a single newline when given no arguments" do
      expect(STDOUT).to receive(:print).with("\n")
      Lasp::execute('(println)')
    end
  end
end
