require "lasp/eval"
require "lasp/parser"
require "tempfile"

def lasp_eval(program, env = Lasp::global_env)
  Lasp::eval(Lasp::Parser.new.parse(program), env)
end

module Lasp
  describe "eval" do
    it "handles simple forms" do
      expect(lasp_eval("(+ 1 1)")).to eq 2
    end

    it "handles nested forms" do
      expect(lasp_eval("(+ 1 (+ 2 2))")).to eq 5
    end

    it "raises a NameError when trying to resolve a non existing symbol" do
      expect { lasp_eval("not-here") }.to raise_error(Lasp::NameError, /not-here is not present in this context/)
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

        it "only allows defining symbols" do
          expect { lasp_eval("(def \"str\" 5)") }.to raise_error(Lasp::ArgumentError)
          expect { lasp_eval("(def (list) 5)") }.to raise_error(Lasp::ArgumentError)
        end
      end

      describe "fn" do
        it "creates a function" do
          expect(lasp_eval("(fn (x) (+ x 1))")).to be_a Fn
        end

        it "enforces arity" do
          expect {
            lasp_eval("((fn (x) (+ x 1)) 3 6)")
          }.to raise_error(Lasp::ArgumentError, "wrong number of arguments (2 for 1)")
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

      describe "quote" do
        it "returns symbol without evaluating it" do
          expect(lasp_eval("(quote f)")).to eq :f
        end

        it "returns form without evaluating it" do
          expect(lasp_eval("(quote (f 1 2))")).to eq [:f, 1, 2]
        end

        it "only quotes the first argument" do
          expect(lasp_eval("(quote f g)")).to eq :f
        end
      end

      describe "macro" do
        it "creates macros" do
          expect(lasp_eval("(macro (x) x)")).to be_a Macro
        end

        it "gives macros unevaluated forms as arguments" do
          expect(lasp_eval("((macro (one op two) (list op one two)) 1 + 2)")).to eq 3
        end
      end
    end

    it "does ruby interop" do
      expect(lasp_eval('(. "hello" :upcase)')).to eq "HELLO"
    end

    it "requires files" do
      Tempfile.open("lasp-test") do |file|
        file.write("(def test true)")
        file.rewind

        lasp_eval("(require \"#{file.path}\")")
        expect(lasp_eval("test")).to eq true
      end
    end
  end
end
