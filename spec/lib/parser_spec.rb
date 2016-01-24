require "lasp/parser"

module Lasp
  describe "parse" do
    it "tokenizes strings" do
      expect(Lasp::tokenize("(func 1 2)")).to eq %w[( func 1 2 )]
    end

    it "tokenizes complex strings" do
      input    = '(+  1.2 2 ( len "test test ")) ' # intentionally messy whitespace
      expected = ["(", "+", "1.2", "2", "(", "len", "\"test test \"", ")", ")"]

      expect(Lasp::tokenize(input)).to eq expected
    end

    it "parses forms" do
      input  = "(func 1  2 (+ 1 2 )) "
      parsed = [:func, 1, 2, [:+, 1, 2]]

      expect(Lasp::parse(input)).to eq parsed
    end

    it "parses complex forms" do
      input  = "((fn (x) (+ x 1)) 10)"
      parsed = [[:fn, [:x], [:+, :x, 1]], 10]

      expect(Lasp::parse(input)).to eq parsed
    end

    it "handles comments and whitespace" do
      input  = <<-LASP
        ; This is a comment
        (+ 1 2) ; End of line comment
      LASP
      parsed = [:+, 1, 2]

      expect(Lasp::parse(input)).to eq parsed
    end

    it "returns nil when input is empty" do
      expect(Lasp::parse("")).to eq nil
    end

    describe "datatypes" do
      it "integers" do
        expect(Lasp::parse("7")).to eq 7
        expect(Lasp::parse("-7")).to eq -7
      end

      it "floats" do
        expect(Lasp::parse("7.5")).to eq 7.5
        expect(Lasp::parse("-7.5")).to eq -7.5
      end

      it "booleans" do
        expect(Lasp::parse("true")).to eq true
        expect(Lasp::parse("false")).to eq false
      end

      it "nil" do
        expect(Lasp::parse("nil")).to eq nil
      end

      it "keywords" do
        expect(Lasp::parse("func")).to eq :func
      end

      it "strings" do
        expect(Lasp::parse('"a quick brown fox"')).to eq "a quick brown fox"
      end

      it "symbol-style strings" do
        expect(Lasp::parse(":justastring")).to eq "justastring"
      end
    end
  end
end
