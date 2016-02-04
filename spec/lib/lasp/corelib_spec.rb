require "lasp/corelib"
require "tempfile"

module Lasp
  describe "corelib" do
    it "+" do
      expect(CORELIB[:+].(1, 2, 3)).to eq 6
    end

    it "-" do
      expect(CORELIB[:-].(1, 2, 3)).to eq -4
    end

    it "*" do
      expect(CORELIB[:*].(2, 3, 4)).to eq 24
    end

    it "*" do
      expect(CORELIB[:/].(20, 2, 2)).to eq 5
    end

    it "<" do
      expect(CORELIB[:<].(20, 10)).to eq false
      expect(CORELIB[:<].(10, 11, 12)).to eq true
      expect(CORELIB[:<].(10, 11, 10)).to eq false
      expect(CORELIB[:<].(10, 10)).to eq false
    end

    it ">" do
      expect(CORELIB[:>].(20, 10)).to eq true
      expect(CORELIB[:>].(10, 9, 8)).to eq true
      expect(CORELIB[:>].(10, 9, 10)).to eq false
      expect(CORELIB[:>].(10, 10)).to eq false
    end

    it "=" do
      expect(CORELIB[:"="].(20, 20, 2)).to eq false
      expect(CORELIB[:"="].(20, 20, 20)).to eq true
      expect(CORELIB[:"="].(20)).to eq true
    end

    it "<=" do
      expect(CORELIB[:"<="].(20, 20, 30)).to eq true
      expect(CORELIB[:"<="].(20, 20, 10)).to eq false
      expect(CORELIB[:"<="].(20, 20)).to eq true
    end

    it ">=" do
      expect(CORELIB[:">="].(20, 20, 30)).to eq false
      expect(CORELIB[:">="].(20, 20, 10)).to eq true
      expect(CORELIB[:">="].(20, 20)).to eq true
    end

    it "list" do
      expect(CORELIB[:list].(1, 2, 3)).to eq [1, 2, 3]
    end

    it "head" do
      expect(CORELIB[:head].([1, 2, 3])).to eq 1
      expect(CORELIB[:head].([])).to eq nil
    end

    it "tail" do
      expect(CORELIB[:tail].([1, 2, 3])).to eq [2, 3]
      expect(CORELIB[:tail].([])).to eq []
    end

    it "cons" do
      expect(CORELIB[:cons].(1, [2, 3])).to eq [1, 2, 3]
      expect(CORELIB[:cons].(1, [])).to eq [1]
    end

    describe "dict" do
      it "creates a dict" do
        expect(CORELIB[:dict].("one", 1, "two", 2)).to eq("one" => 1, "two" => 2)
      end

      it "errors when given an uneven number of arguments" do
        expect { CORELIB[:dict].("one", 1, "two") }.to raise_error ::ArgumentError, /odd number of arguments/
      end
    end

    describe "get" do
      it "returns item of index in list" do
        expect(CORELIB[:get].(0, [1, 2, 3])).to eq 1
      end

      it "returns item of key in dict" do
        expect(CORELIB[:get].("one", {"one"=>1, "two"=>2})).to eq 1
      end
    end

    describe "assoc" do
      it "associates a key with a value in a hash" do
        expect(CORELIB[:assoc].({}, "one", 1)).to eq("one" => 1)
      end

      it "replaces the value if already present" do
        expect(CORELIB[:assoc].({"one" => 1}, "one", 2)).to eq("one" => 2)
      end

      it "does not change the original data structure" do
        data = {"one" => 1}
        expect{ CORELIB[:assoc].(data, "one", 2) }.not_to change { data }
      end

      it "associates an index with a value in a list" do
        expect(CORELIB[:assoc].([1, 2, 3], 0, 0)).to eq [0, 2, 3]
      end

      it "errors when trying to use a non-integer key in a list" do
        expect { CORELIB[:assoc].([1, 2, 3], "one", 1) }.to raise_error TypeError
      end
    end

    describe "dissoc" do
      it "returns a hash without a value" do
        expect(CORELIB[:dissoc].({"one"=>1, "two"=>2}, "one")).to eq("two" => 2)
      end

      it "does not change the original data structure" do
        data = {"one"=>1, "two"=>2}
        expect{ CORELIB[:dissoc].(data, "one") }.not_to change { data }
      end
    end

    it "not" do
      expect(CORELIB[:not].(true)).to eq false
    end

    it "println" do
      allow(STDOUT).to receive(:puts)
      CORELIB[:println].(5)
      expect(STDOUT).to have_received(:puts).with(5)
    end

    it "apply" do
      plus = CORELIB[:+]
      expect(CORELIB[:apply].(plus, [1, 2, 3])).to eq 6
    end

    it "interop" do
      expect(CORELIB[:"."].("01011101", "to_i", 2)).to eq 93
    end

    it "require" do
      path = "./path/to/lasp_file.lasp"
      expect(Lasp).to receive(:execute_file).with(path)
      CORELIB[:require].(path)
    end
  end
end
