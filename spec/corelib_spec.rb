require "./lib/corelib"

module Lasp
  describe CORELIB do
    it "+" do
      expect(described_class[:+].({}, 1, 2, 3)).to eq 6
    end

    it "-" do
      expect(described_class[:-].({}, 1, 2, 3)).to eq -4
    end

    it "*" do
      expect(described_class[:*].({}, 2, 3, 4)).to eq 24
    end

    it "*" do
      expect(described_class[:/].({}, 20, 2, 2)).to eq 5
    end

    it "<" do
      expect(described_class[:<].({}, 20, 10)).to eq false
      expect(described_class[:<].({}, 10, 11, 12)).to eq true
      expect(described_class[:<].({}, 10, 11, 10)).to eq false
    end

    it ">" do
      expect(described_class[:>].({}, 20, 10)).to eq true
      expect(described_class[:>].({}, 10, 9, 8)).to eq true
      expect(described_class[:>].({}, 10, 9, 10)).to eq false
    end

    it "=" do
      expect(described_class[:"="].({}, 20, 20, 2)).to eq false
      expect(described_class[:"="].({}, 20, 20, 20)).to eq true
      expect(described_class[:"="].({}, 20)).to eq true
    end

    it "list" do
      expect(described_class[:list].({}, 1, 2, 3)).to eq [1, 2, 3]
    end

    it "head" do
      expect(described_class[:head].({}, [1, 2, 3])).to eq 1
      expect(described_class[:head].({}, [])).to eq nil
    end

    it "tail" do
      expect(described_class[:tail].({}, [1, 2, 3])).to eq [2, 3]
      expect(described_class[:tail].({}, [])).to eq []
    end

    it "cons" do
      expect(described_class[:cons].({}, 1, [2, 3])).to eq [1, 2, 3]
      expect(described_class[:cons].({}, 1, [])).to eq [1]
    end

    it "not" do
      expect(described_class[:not].({}, true)).to eq false
    end

    it "outputs to the console" do
      allow(STDOUT).to receive(:puts)
      described_class[:println].({}, 5)
      expect(STDOUT).to have_received(:puts).with(5)
    end

    it "interops" do
      expect(described_class[:"."].({}, "str", "bytesize")).to eq 3
    end
  end
end
