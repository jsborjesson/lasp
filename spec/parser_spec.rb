require "./lib/parser"

module Lasp
  describe "parse" do
    it "tokenizes a string" do
      expect(Lasp::tokenize("(func 1 2)")).to eq %w[( func 1 2 )]
    end

    it "parses forms" do
      input  = "(func true 2.7 (+ false 2))"
      parsed = [:func, true, 2.7, [:+, false, 2]]

      expect(Lasp::parse(input)).to eq parsed
    end

    it "parses complex forms" do
      input  = "((fn (x) (+ x 1)) 10)"
      parsed = [[:fn, [:x], [:+, :x, 1]], 10]

      expect(Lasp::parse(input)).to eq parsed
    end
  end
end
