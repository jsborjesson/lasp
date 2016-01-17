require "lasp/eval"

def lasp_eval(program, env = Lasp::global_env)
  Lasp::eval(Lasp::parse(program), env)
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
      describe "def" do
        it "defines values in the environment" do
          lasp_eval("(def five 5)")

          expect(Lasp::global_env[:five]).to eq 5
        end

        it "returns the value it sets" do
          expect(lasp_eval("(def five 5)")).to eq 5
        end
      end

      describe "fn" do
        it "creates a function" do
          expect(lasp_eval("(fn (x) (+ x 1))")).to be_a Proc
        end

        it "enforces arity" do
          expect {
            lasp_eval("((fn (x) (+ x 1)) 3 6)")
          }.to raise_error(ArgumentError, "wrong number of arguments (2 for 1)")
        end

        it "executes defined functions" do
          lasp_eval("(def inc (fn (x) (+ x 1)))")
          expect(lasp_eval("(inc 1)")).to eq 2
        end

        it "handles closures" do
          # This is a function that takes an argument, and returns another
          # function that simply returns the argument of the outer function on
          # invocation; this is what the outer parenthesis are for: to execute
          # the inner function too. What is important here is that the inner
          # function has access to the environment in the outer one.
          expect(lasp_eval("(((fn (x) (fn () x)) 42))")).to eq 42
        end
      end

      describe "do" do
        it "executes multiple statements in order" do
          mock_fn  = spy
          test_env = { test: mock_fn }

          lasp_eval("(do (test 1) (test 2))", test_env)

          expect(mock_fn).to have_received(:call).with(1).ordered
          expect(mock_fn).to have_received(:call).with(2).ordered
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
          # This is different than simply not returning its result, the other
          # form cannot even be evaluated.
          mock_fn  = spy
          test_env = Lasp::global_env.merge({ test: mock_fn })

          lasp_eval('(if (= 1 1) true (test "not evaled!"))', test_env)

          expect(mock_fn).not_to have_received(:call)
        end
      end
    end

    it "does ruby interop" do
      expect(lasp_eval('(. "hello" :upcase)')).to eq "HELLO"
    end
  end
end
