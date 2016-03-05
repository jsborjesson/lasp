require "lasp/env"

module Lasp
  describe Env do
    subject { described_class.new(one: 1, two: 2) }

    it "returns a new instance of Env when merged" do
      merged = subject.merge(three: 3)

      expect(merged).to be_an Env
    end
  end
end
