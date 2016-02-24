require "lasp/variadic_params"

module Lasp
  describe VariadicParams do
    let(:params) { described_class.new([:one, :two, :&, :other]) }

    it "gives you ordered parameters" do
      expect(params.ordered).to eq [:one, :two]
    end

    it "has nice to_s output" do
      expect(params.to_s).to eq "(one two & other)"
    end

    it "reports arity as a string" do
      expect(params.arity).to eq "2+"
    end

    it "reports length as the minimum number of parameters" do
      expect(params.length).to eq 2
    end

    it "calculates if a number of arguments matches its arity" do
      expect(params.matches_arity?(1)).to eq false
      expect(params.matches_arity?(2)).to eq true
      expect(params.matches_arity?(3)).to eq true
    end
  end
end
