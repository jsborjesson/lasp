require "lasp/eval"

def lasp_eval(program)
  Lasp::eval(Lasp::parse(program), Lasp::global_env)
end

module Lasp
  describe "eval" do
    it "handles simple forms" do
      expect(lasp_eval("(+ 1 1)")).to eq 2
    end

    it "handles nested forms" do
      expect(lasp_eval("(+ 1 (+ 2 2))")).to eq 5
    end

    describe "special forms" do
      it "def defines values in the environment" do
        lasp_eval("(def five 5)")

        expect(Lasp::global_env[:five]).to eq 5
      end

      it "fn creates a function" do
        expect(lasp_eval("((fn (x) (+ x 1)) 10)")).to eq 11
      end

      it "user-defined functions are executable" do
        lasp_eval("(def inc (fn (x) (+ x 1)))")
        expect(lasp_eval("(inc 1)")).to eq 2
      end

      describe "do" do
        it "executes multiple statements" do
          allow(STDOUT).to receive(:puts)
          lasp_eval("(do (println 1) (println 2))")

          expect(STDOUT).to have_received(:puts).with(1).ordered
          expect(STDOUT).to have_received(:puts).with(2).ordered
        end

        it "returns the value of the last statement" do
          expect(lasp_eval("(do (+ 1 1) (+ 1 2))")).to eq 3
        end
      end

      describe "if" do
        it "returns the result of the correct form" do
          expect(lasp_eval("(if (= 1 1) true false)")).to eq true
          expect(lasp_eval("(if (= 1 2) true false)")).to eq false
          expect(lasp_eval("(if (= 1 2) true)")).to eq nil
        end

        it "does not evaluate the other form" do
          allow(STDOUT).to receive(:puts)
          lasp_eval('(if (= 1 1) true (println "not evaled!"))')
          expect(STDOUT).not_to have_received(:puts)
        end
      end
    end

    it "handles closures" do
      # This is a function that takes an argument, and returns another function
      # that simply returns the argument of the outer function on invocation; this is what
      # the outer parenthesis are for: to execute the inner function too. What is important here
      # is that the inner function has access to the env in the outer one.
      expect(lasp_eval("(((fn (x) (fn () x)) 42))")).to eq 42
    end

    it "does ruby interop" do
      expect(lasp_eval('(. "hello" :upcase)')).to eq "HELLO"
    end
  end
end
