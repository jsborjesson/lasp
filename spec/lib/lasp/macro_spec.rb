require "lasp/macro"

module Lasp
  describe Macro do
    it "is inspectable" do
      macro = described_class.new(%i[a b & c], double, double)
      expect(macro.inspect).to eq "#<Macro (a b & c)>"
    end
  end
end
