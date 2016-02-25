require "lasp/params"

module Lasp
  describe Params do
    context "non-variadic parameters" do
      let(:params) { described_class.new([:one, :two]) }

      it "has nice to_s output" do
        expect(params.to_s).to eq "(one two)"
      end

      it "maps parameters to arguments in a hash" do
        expect(params.with_args([1, 2])).to eq({ one: 1, two: 2 })
      end

      it "enforces arity" do
        expect { params.with_args([1, 2, 3]) }.to raise_error(Lasp::ArgumentError, "wrong number of arguments (3 for 2)")
        expect { params.with_args([1]) }.to raise_error(Lasp::ArgumentError, "wrong number of arguments (1 for 2)")
      end

      it "only counts the last underscore" do
        ignored_params = described_class.new([:_, :_, :three])
        expect(ignored_params.with_args([1, 2, 3])).to eq({ _: 2, three: 3 })
      end
    end
  end
end
