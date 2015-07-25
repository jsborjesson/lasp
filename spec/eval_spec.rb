require "./lib/eval"

module Lasp
  describe "eval" do
    it "handles simple forms" do
      expect(Lasp::execute("(+ 1 1)")).to eq 2
    end

    it "handles nested forms" do
      expect(Lasp::execute("(+ 1 (+ 2 2))")).to eq 5
    end

    describe "special forms" do
      it "def defines values in the environment" do
        Lasp::execute("(def five 5)")

        expect(Lasp::global_env[:five]).to eq 5
      end

      it "fn creates a function" do
        expect(Lasp::execute("((fn (x) (+ x 1)) 10)")).to eq 11
      end

      it "def can define functions" do
        Lasp::execute("(def inc (fn (x) (+ x 1)))")
        expect(Lasp::execute("(inc 1)")).to eq 2
      end

      it "begin executes multiple statements" do
        allow(STDOUT).to receive(:puts)
        Lasp::execute("(begin (println 1) (println 2))")

        expect(STDOUT).to have_received(:puts).with(1).ordered
        expect(STDOUT).to have_received(:puts).with(2).ordered
      end
    end
  end
end
