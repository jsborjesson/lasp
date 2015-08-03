require "lasp/corelib"

module Lasp
  describe "corelib" do
    it "+" do
      expect(CORELIB[:+].({}, 1, 2, 3)).to eq 6
    end

    it "-" do
      expect(CORELIB[:-].({}, 1, 2, 3)).to eq -4
    end

    it "*" do
      expect(CORELIB[:*].({}, 2, 3, 4)).to eq 24
    end

    it "*" do
      expect(CORELIB[:/].({}, 20, 2, 2)).to eq 5
    end

    it "<" do
      expect(CORELIB[:<].({}, 20, 10)).to eq false
      expect(CORELIB[:<].({}, 10, 11, 12)).to eq true
      expect(CORELIB[:<].({}, 10, 11, 10)).to eq false
    end

    it ">" do
      expect(CORELIB[:>].({}, 20, 10)).to eq true
      expect(CORELIB[:>].({}, 10, 9, 8)).to eq true
      expect(CORELIB[:>].({}, 10, 9, 10)).to eq false
    end

    it "=" do
      expect(CORELIB[:"="].({}, 20, 20, 2)).to eq false
      expect(CORELIB[:"="].({}, 20, 20, 20)).to eq true
      expect(CORELIB[:"="].({}, 20)).to eq true
    end

    it "list" do
      expect(CORELIB[:list].({}, 1, 2, 3)).to eq [1, 2, 3]
    end

    it "head" do
      expect(CORELIB[:head].({}, [1, 2, 3])).to eq 1
      expect(CORELIB[:head].({}, [])).to eq nil
    end

    it "tail" do
      expect(CORELIB[:tail].({}, [1, 2, 3])).to eq [2, 3]
      expect(CORELIB[:tail].({}, [])).to eq []
    end

    it "cons" do
      expect(CORELIB[:cons].({}, 1, [2, 3])).to eq [1, 2, 3]
      expect(CORELIB[:cons].({}, 1, [])).to eq [1]
    end

    it "not" do
      expect(CORELIB[:not].({}, true)).to eq false
    end

    it "println" do
      allow(STDOUT).to receive(:puts)
      CORELIB[:println].({}, 5)
      expect(STDOUT).to have_received(:puts).with(5)
    end

    it "interop" do
      expect(CORELIB[:"."].({}, "str", "bytesize")).to eq 3
    end
  end
end
