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

    it "def" do
      env = {}
      CORE_LIB[:def].(env, :foo, 5)
      expect(env).to eq(foo: 5)
    end
  end
end
