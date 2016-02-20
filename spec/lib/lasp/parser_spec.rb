require "lasp/parser"

module Lasp
  describe Parser do
    subject { described_class.new }

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

    it "parses forms" do
      input  = "(func 1  2 (+ 1 2 )) "
      parsed = [:func, 1, 2, [:+, 1, 2]]

      expect(subject.parse(input)).to eq parsed
    end

    it "parses complex forms" do
      input  = "((fn (x) (+ x 1)) 10)"
      parsed = [[:fn, [:x], [:+, :x, 1]], 10]

      expect(subject.parse(input)).to eq parsed
    end

    it "surrounds quoted forms in quote" do
      input  = "('f '(gh 1 2))"
      parsed = [[:quote, :f], [:quote, [:gh, 1, 2]]]

      expect(subject.parse(input)).to eq parsed
    end

    it "handles comments and whitespace" do
      input  = <<-LASP
        ; This is a comment
        (+ 1 2) ; End of line comment
      LASP
      parsed = [:+, 1, 2]

      expect(subject.parse(input)).to eq parsed
    end

    it "returns nil when input is empty" do
      expect(subject.parse("")).to eq nil
    end

    describe "datatypes" do
      it "integers" do
        expect(subject.parse("7")).to eq 7
        expect(subject.parse("-7")).to eq -7
      end

      it "decimals" do
        expect(subject.parse("7.5")).to eq 7.5
        expect(subject.parse("-7.5")).to eq -7.5
      end

      it "booleans" do
        expect(subject.parse("true")).to eq true
        expect(subject.parse("false")).to eq false
      end

      it "nil" do
        expect(subject.parse("nil")).to eq nil
      end

      it "keywords" do
        expect(subject.parse("func")).to eq :func
      end

      describe "strings" do
        it "parses strings with double-quotes" do
          expect(subject.parse('"a quick brown fox"')).to eq "a quick brown fox"
        end

        it "parses strings with leading colons" do
          expect(subject.parse(":just-a-string")).to eq "just-a-string"
        end

        it "parses strings with escape characters" do
          expect(subject.parse('"hello\nworld"')).to eq "hello\nworld"
        end
      end
    end
  end
end
