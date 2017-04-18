require "lasp"
require "lasp/fn"

module Lasp
  describe Fn do
    it "interprets its body with arguments set in the environment" do
      fn = described_class.new([:a, :b], [:+, :a, :b], Lasp.env_with_corelib)
      expect(fn.call(3, 4)).to eq 7
    end

    it "is inspectable" do
      fn = described_class.new([:a, :b, :&, :c], [:+, :a, :b], double)
      expect(fn.inspect).to eq "#<Fn (a b & c)>"
    end

    describe "nameablility" do
      let(:fn) {
        described_class.new([:arg], [], double).tap do |fn|
          fn.name = :"test-function"
        end
      }

      it "is nameable" do
        expect(fn.name).to eq :"test-function"
      end

      it "can only be named once" do
        fn.name = :"other-name"
        expect(fn.name).to eq :"test-function"
      end

      it "includes the name in the inspect output when it exists" do
        expect(fn.inspect).to eq "#<Fn test-function (arg)>"
      end
    end
  end
end
