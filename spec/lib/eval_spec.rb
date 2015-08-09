require "lasp"
require "tempfile"

module Lasp
  describe "evaluation" do
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

      describe "do" do
        it "do executes multiple statements" do
          allow(STDOUT).to receive(:puts)
          Lasp::execute("(do (println 1) (println 2))")

          expect(STDOUT).to have_received(:puts).with(1).ordered
          expect(STDOUT).to have_received(:puts).with(2).ordered
        end

        it "do returns the value of the last statement" do
          expect(Lasp::execute("(do (+ 1 1) (+ 1 2))")).to eq 3
        end
      end

      describe "if" do
        it "returns the result of the correct form" do
          expect(Lasp::execute("(if (= 1 1) true false)")).to eq true
          expect(Lasp::execute("(if (= 1 2) true false)")).to eq false
          expect(Lasp::execute("(if (= 1 2) true)")).to eq nil
        end

        it "does not evaluate the other form" do
          allow(STDOUT).to receive(:puts)
          Lasp::execute('(if (= 1 1) true (println "not evaled!"))')
          expect(STDOUT).not_to have_received(:puts)
        end
      end
    end

    it "wraps the top level with a do block when reading lasp files" do
      Tempfile.open("lasp-test") do |file|
        file.write('(+ "fi" "rst") (+ "la" "st")')
        file.rewind

        expect(Lasp::execute_file(file.path)).to eq "last"
      end
    end

    it "handles closures" do
      expect(Lasp::execute("(((fn (x) (fn () x)) 42))")).to eq 42
    end

    it "does ruby interop" do
      expect(Lasp::execute('(. "hello" :upcase)')).to eq "HELLO"
    end
  end
end
