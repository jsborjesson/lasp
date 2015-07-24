require "./lib/eval"

module Lasp
  describe "eval" do
    it "handles simple addition" do
      expect(Lasp::eval(Lasp::parse("(+ 1 1)"))).to eq 2
    end
  end
end
