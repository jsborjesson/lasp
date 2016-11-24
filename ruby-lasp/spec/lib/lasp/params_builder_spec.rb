require "lasp/params_builder"

module Lasp
  describe ParamsBuilder do
    it "creates a Params object for normal params" do
      expect(described_class.build([:a, :b])).to be_a Params
    end

    it "creates a VariadicParams object when there is an ampersand" do
      expect(described_class.build([:a, :b, :&, :c])).to be_a VariadicParams
    end

    it "fails when params are not passed as a list" do
      expect {
        described_class.build(:a)
      }.to raise_error(SyntaxError, /parameters must be a list/)
    end

    it "fails when the same parameter name is used more than once" do
      expect {
        described_class.build([:a, :a])
      }.to raise_error(SyntaxError, /parameter names must be unique/)
    end

    it "allows _ to be used several times" do
      expect(described_class.build([:_, :_])).to be_a Params
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
