require "./lib/core_lib"

module Lasp
  describe CORE_LIB do
    it "+" do
      expect(CORE_LIB[:+].({}, 1, 2, 3)).to eq 6
    end

    it "-" do
      expect(CORE_LIB[:-].({}, 1, 2, 3)).to eq -4
    end

    it "*" do
      expect(CORE_LIB[:*].({}, 2, 3, 4)).to eq 24
    end

    it "*" do
      expect(CORE_LIB[:/].({}, 20, 2, 2)).to eq 5
    end

    it "=" do
      expect(CORE_LIB[:"="].({}, 20, 20, 2)).to eq false
      expect(CORE_LIB[:"="].({}, 20, 20, 20)).to eq true
      expect(CORE_LIB[:"="].({}, 20)).to eq true
    end

    it "list" do
      expect(CORE_LIB[:list].({}, 1, 2, 3)).to eq [1, 2, 3]
    end

    it "head" do
      expect(CORE_LIB[:head].({}, [1, 2, 3])).to eq 1
      expect(CORE_LIB[:head].({}, [])).to eq nil
    end

    it "tail" do
      expect(CORE_LIB[:tail].({}, [1, 2, 3])).to eq [2, 3]
      expect(CORE_LIB[:tail].({}, [])).to eq []
    end

    it "cons" do
      expect(CORE_LIB[:cons].({}, 1, [2, 3])).to eq [1, 2, 3]
      expect(CORE_LIB[:cons].({}, 1, [])).to eq [1]
    end
  end
end
