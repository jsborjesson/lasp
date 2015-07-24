require "./lib/eval"

module Lasp
  describe "eval" do
    it "handles simple forms" do
      expect(Lasp::eval(Lasp::parse("(+ 1 1)"))).to eq 2
    end

    it "handles nested forms" do
      expect(Lasp::eval(Lasp::parse("(+ 1 (+ 2 2))"))).to eq 5
    end
  end
end
