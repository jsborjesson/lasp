require "./lib/eval"

module Lasp
  describe "eval" do
    it "handles simple forms" do
      expect(Lasp::execute("(+ 1 1)")).to eq 2
    end

    it "handles nested forms" do
      expect(Lasp::execute("(+ 1 (+ 2 2))")).to eq 5
    end

    it "sets values in the global environment with def" do
      Lasp::execute("(def five 5)")

      expect(Lasp::global_env[:five]).to eq 5
    end

    it "creates and executes functions with fn" do
      expect(Lasp::execute("((fn (x) (+ x 1)) 10)")).to eq 11
    end

    it "can define functions" do
      Lasp::execute("(def inc (fn (x) (+ x 1)))")
      expect(Lasp::execute("(inc 1)")).to eq 2
    end
  end
end
