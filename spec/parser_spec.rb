require "./lib/parser"

module Lasp
  describe Parser do
    it "tokenizes a string" do
      expect(described_class.tokenize("(func 1 2)")).to eq %w[( func 1 2 )]
    end

    it "parses forms" do
      input  = "(func 42 27 (+ 1 2))"
      parsed = [:func, 42, 27, [:+, 1, 2]]

      expect(described_class.parse(input)).to eq parsed
    end
  end
end
