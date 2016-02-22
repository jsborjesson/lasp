require "lasp/lexer"

describe Lexer do
  subject { described_class }

  it "tokenizes strings" do
    expect(subject.tokenize("(func 1 2)")).to eq %w[( func 1 2 )]
  end

  it "tokenizes complex strings" do
    input    = '(+  1.2 2 ( len "test test (")) ' # intentionally messy whitespace
    expected = ["(", "+", "1.2", "2", "(", "len", "\"test test (\"", ")", ")"]

    expect(subject.tokenize(input)).to eq expected
  end

  it "tokenizes quotes" do
    input    = "('f '(gh 1 2))"
    expected = ["(", "'", "f", "'", "(", "gh", "1", "2", ")", ")"]

    expect(subject.tokenize(input)).to eq expected
  end

  it "tokenizes strings with escaped double-quotes" do
    input    = '(str "one \" two")'
    expected = ['(', 'str', '"one \\" two"', ')']

    expect(subject.tokenize(input)).to eq expected
  end

  it "ignores comments and whitespace" do
    input  = <<-LASP
      ; This is a comment
      (+ 1  2  ) ; End of line comment
    LASP
    tokens = ["(", "+", "1", "2", ")"]

    expect(subject.tokenize(input)).to eq tokens
  end
end
