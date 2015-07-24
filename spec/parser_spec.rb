require "./lib/parser"

module Lasp
  describe "parse" do
    it "tokenizes a string" do
      expect(Lasp::tokenize("(func 1 2)")).to eq %w[( func 1 2 )]
    end

    it "parses forms" do
      input  = "(func 42 2.7 (+ 1 2))"
      parsed = [:func, 42, 2.7, [:+, 1, 2]]

      expect(Lasp::parse(input)).to eq parsed
    end
  end
end
