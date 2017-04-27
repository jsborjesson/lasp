require "lasp/variadic_params"

module Lasp
  describe VariadicParams do
    let(:params) { described_class.new(%i[one two & other]) }

    it "has nice to_s output" do
      expect(params.to_s).to eq "(one two & other)"
    end

    it "raises an error when given too few arguments" do
      expect { params.with_args([1]) }.to raise_error(Lasp::ArgumentError, "wrong number of arguments (1 for 2+)")
    end

    it "puts all superflous arguments in a list" do
      expect(params.with_args([1, 2, 3, 4])).to eq(one: 1, two: 2, other: [3, 4])
    end

    it "sets the rest to an empty list if no superflous arguments are given" do
      expect(params.with_args([1, 2])).to eq(one: 1, two: 2, other: [])
    end
  end
end
