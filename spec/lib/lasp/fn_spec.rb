require "lasp"
require "lasp/fn"

module Lasp
  describe Fn do
    it "implements call" do
      fn = described_class.new([:a, :b], [:+, :a, :b], Lasp::global_env)
      expect(fn.(3, 4)).to eq 7
    end

    it "is inspectable" do
      fn = described_class.new([:a, :b, :&, :c], [:+, :a, :b], {})
      expect(fn.inspect).to eq "#<Fn (a b & c)>"
    end

    describe "arity" do
      it "enforces arity" do
        expect {
          fn = described_class.new([:a, :b], [:+, :a, :b], Lasp::global_env)
          fn.(1, 2, 3)
        }.to raise_error(Lasp::ArgumentError, "wrong number of arguments (3 for 2)")
      end

      it "allows rest arguments with &" do
        fn = described_class.new([:&, :a], :a, Lasp::global_env)

        expect(fn.()).to eq []
        expect(fn.(1, 2)).to eq [1, 2]
        expect(fn.(1, 2, 3)).to eq [1, 2, 3]
      end

      it "allows variable arity with some fixed arguments" do
        fn = described_class.new([:a, :&, :b], [:list, :a, :b], Lasp::global_env)

        expect(fn.(1, 2)).to eq [1, [2]]
        expect(fn.(1, 2, 3)).to eq [1, [2, 3]]
      end

      it "fails when called with too few arguments" do
        fn = described_class.new([:a, :&, :b], [:list, :a, :b], Lasp::global_env)

        expect { fn.call }.to raise_error(Lasp::ArgumentError, "wrong number of arguments (0 for 1+)")
      end

      it "sets the rest arguments to an empty list when none are sent" do
        fn = described_class.new([:a, :&, :b], [:list, :a, :b], Lasp::global_env)

        expect(fn.(1)).to eq [1, []]
      end
    end
  end
end
