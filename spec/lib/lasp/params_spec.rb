require "lasp/params"

module Lasp
  describe Params do
    context "non-variadic parameters" do
      let(:params) { described_class.new([:one, :two]) }

      it "gives you ordered parameters" do
        expect(params.ordered).to eq [:one, :two]
      end

      it "has nice to_s output" do
        expect(params.to_s).to eq "(one two)"
      end

      it "reports arity as a string" do
        expect(params.arity).to eq "2"
      end

      it "reports length as the number of parameters" do
        expect(params.length).to eq 2
      end

      it "calculates if a number of arguments matches its arity" do
        expect(params.matches_arity?(1)).to eq false
        expect(params.matches_arity?(2)).to eq true
        expect(params.matches_arity?(3)).to eq false
      end
    end
  end

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

  describe ParamsBuilder do
    it "fails when params are not passed as a list" do
      expect {
        described_class.build(:a)
      }.to raise_error(SyntaxError, /parameters must be a list/)
    end

    it "fails when the same parameter name is used more than once" do
      expect {
        described_class.build([:a, :a])
      }.to raise_error(SyntaxError, /parameter names have to be unique/)
    end

    it "fails when more than one ampersand is used in a function definition" do
      expect {
        described_class.build([:a, :&, :b, :&, :c])
      }.to raise_error(SyntaxError, /rest-arguments may only be used once, at the end, with a single binding/)
    end

    it "fails when more than one binding is used after the ampersand" do
      expect {
        described_class.build([:a, :&, :b, :c])
      }.to raise_error(SyntaxError, /rest-arguments may only be used once, at the end, with a single binding/)
    end

    it "fails when & is last" do
      expect {
        described_class.build([:a, :&])
      }.to raise_error(SyntaxError, /rest-arguments may only be used once, at the end, with a single binding/)
    end
  end
end
