require "lasp/fn"
require "lasp"

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

    it "fails at instantiation when the same parameter name is used more than once" do
      expect {
        described_class.new([:a, :a], :a, {})
      }.to raise_error(Lasp::SyntaxError, /Parameter names have to be unique. a is used more than once/)
    end

    describe "arity" do
      it "enforces arity" do
        expect {
          fn = described_class.new([:a, :b], [:+, :a, :b], Lasp::global_env)
          fn.(1, 2, 3)
        }.to raise_error(ArgumentError, "wrong number of arguments (3 for 2)")
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

        expect { fn.call }.to raise_error(ArgumentError, "wrong number of arguments (0 for 1+)")
      end

      it "sets the rest arguments to an empty list when none are sent" do
        fn = described_class.new([:a, :&, :b], [:list, :a, :b], Lasp::global_env)

        expect(fn.(1)).to eq [1, []]
      end

      it "fails at instantiation when more than one ampersand is used in a function definition" do
        expect {
          described_class.new([:a, :&, :b, :&, :c], :a, {})
        }.to raise_error(Lasp::SyntaxError, /Rest-arguments may only be used once, at the end, with a single binding./)
      end

      it "fails at instantiation when more than one binding is used after the ampersand" do
        expect {
          described_class.new([:a, :&, :b, :c], :a, {})
        }.to raise_error(Lasp::SyntaxError, /Rest-arguments may only be used once, at the end, with a single binding./)
      end

      it "fails at instantiation when & is last" do
        expect {
          described_class.new([:a, :&], :a, {})
        }.to raise_error(Lasp::SyntaxError, /Rest-arguments may only be used once, at the end, with a single binding./)
      end
    end
  end
end
