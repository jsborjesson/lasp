require "lasp"
require "lasp/fn"

module Lasp
  describe Fn do
    it "interprets its body with arguments set in the environment" do
      fn = described_class.new(%i[a b], %i[+ a b], Lasp.env_with_corelib)
      expect(fn.call(3, 4)).to eq 7
    end

    it "is inspectable" do
      fn = described_class.new(%i[a b & c], %i[+ a b], double)
      expect(fn.inspect).to eq "#<Fn (a b & c)>"
    end
  end
end
