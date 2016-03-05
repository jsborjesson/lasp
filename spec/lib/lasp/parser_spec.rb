require "lasp/parser"

module Lasp
  describe Parser do
    subject { described_class.new }

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

    it "converts dot-syntax to send" do
      input  = "(.inspect :test)"
      parsed = [:send, "inspect", "test"]

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
          expect(subject.parse(%q{ "\\\\hello\\t\\"world\"\\n\\n" })).to eq %Q{\\hello\t"world"\n\n}
        end

        it "parses unknown escape sequences as the escaped character" do
          expect(subject.parse('"\unknown"')).to eq 'unknown'
        end
      end
    end
  end
end
