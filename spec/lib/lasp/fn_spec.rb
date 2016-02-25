require "lasp"
require "lasp/fn"

module Lasp
  describe Fn do
    it "interprets its body with arguments set in the environment" do
      fn = described_class.new([:a, :b], [:+, :a, :b], Lasp::global_env)
      expect(fn.(3, 4)).to eq 7
    end

    it "is inspectable" do
      fn = described_class.new([:a, :b, :&, :c], [:+, :a, :b], {})
      expect(fn.inspect).to eq "#<Fn (a b & c)>"
    end
  end
end
