require "lasp/corelib"
require "tempfile"

module Lasp
  describe "corelib" do
    it "+" do
      expect(CORELIB[:+].call(1, 2, 3)).to eq 6
    end

    it "-" do
      expect(CORELIB[:-].call(1, 2, 3)).to eq(-4)
    end

    it "*" do
      expect(CORELIB[:*].call(2, 3, 4)).to eq 24
    end

    it "*" do
      expect(CORELIB[:/].call(20, 2, 2)).to eq 5
    end

    it "<" do
      expect(CORELIB[:<].call(20, 10)).to eq false
      expect(CORELIB[:<].call(10, 11, 12)).to eq true
      expect(CORELIB[:<].call(10, 11, 10)).to eq false
      expect(CORELIB[:<].call(10, 10)).to eq false
    end

    it ">" do
      expect(CORELIB[:>].call(20, 10)).to eq true
      expect(CORELIB[:>].call(10, 9, 8)).to eq true
      expect(CORELIB[:>].call(10, 9, 10)).to eq false
      expect(CORELIB[:>].call(10, 10)).to eq false
    end

    it "=" do
      expect(CORELIB[:"="].call(20, 20, 2)).to eq false
      expect(CORELIB[:"="].call(20, 20, 20)).to eq true
      expect(CORELIB[:"="].call(20)).to eq true
    end

    it "<=" do
      expect(CORELIB[:"<="].call(20, 20, 30)).to eq true
      expect(CORELIB[:"<="].call(20, 20, 10)).to eq false
      expect(CORELIB[:"<="].call(20, 20)).to eq true
    end

    it ">=" do
      expect(CORELIB[:">="].call(20, 20, 30)).to eq false
      expect(CORELIB[:">="].call(20, 20, 10)).to eq true
      expect(CORELIB[:">="].call(20, 20)).to eq true
    end

    it "list" do
      expect(CORELIB[:list].call(1, 2, 3)).to eq [1, 2, 3]
    end

    it "head" do
      expect(CORELIB[:head].call([1, 2, 3])).to eq 1
      expect(CORELIB[:head].call([])).to eq nil
    end

    it "tail" do
      expect(CORELIB[:tail].call([1, 2, 3])).to eq [2, 3]
      expect(CORELIB[:tail].call([])).to eq []
    end

    describe "cons" do
      it "adds items to the front of a list" do
        expect(CORELIB[:cons].call(1, [2, 3])).to eq [1, 2, 3]
        expect(CORELIB[:cons].call(1, [])).to eq [1]
      end

      it "does not change the original data structure" do
        original = [2, 3]
        expect { CORELIB[:cons].call(1, original) }.not_to(change { original })
      end
    end

    describe "dict" do
      it "creates a dict" do
        expect(CORELIB[:dict].call("one", 1, "two", 2)).to eq("one" => 1, "two" => 2)
      end

      it "errors when given an uneven number of arguments" do
        expect { CORELIB[:dict].call("one", 1, "two") }.to raise_error ::ArgumentError, /odd number of arguments/
      end
    end

    describe "get" do
      it "returns item of index in list" do
        expect(CORELIB[:get].call(0, [1, 2, 3])).to eq 1
      end

      it "returns item of key in dict" do
        expect(CORELIB[:get].call("one", "one" => 1, "two" => 2)).to eq 1
      end
    end

    describe "assoc" do
      it "associates a key with a value in a hash" do
        expect(CORELIB[:assoc].call({}, "one", 1)).to eq("one" => 1)
      end

      it "replaces the value if already present" do
        expect(CORELIB[:assoc].call({ "one" => 1 }, "one", 2)).to eq("one" => 2)
      end

      it "does not change the original data structure" do
        data = { "one" => 1 }
        expect { CORELIB[:assoc].call(data, "one", 2) }.not_to(change { data })
      end

      it "associates an index with a value in a list" do
        expect(CORELIB[:assoc].call([1, 2, 3], 0, 0)).to eq [0, 2, 3]
      end

      it "errors when trying to use a non-integer key in a list" do
        expect { CORELIB[:assoc].call([1, 2, 3], "one", 1) }.to raise_error TypeError
      end
    end

    describe "dissoc" do
      it "returns a hash without a value" do
        expect(CORELIB[:dissoc].call({ "one" => 1, "two" => 2 }, "one")).to eq("two" => 2)
      end

      it "does not change the original data structure" do
        data = { "one" => 1, "two" => 2 }
        expect { CORELIB[:dissoc].call(data, "one") }.not_to(change { data })
      end
    end

    it "not" do
      expect(CORELIB[:not].call(true)).to eq false
    end

    it "print" do
      allow(STDOUT).to receive(:print)
      CORELIB[:print].call("one", "two")
      expect(STDOUT).to have_received(:print).with("one", "two")
    end

    it "readln" do
      allow(STDIN).to receive(:gets).and_return("test input\n")
      expect(CORELIB[:readln].call).to eq "test input"
    end

    it "apply" do
      plus = CORELIB[:+]
      expect(CORELIB[:apply].call(plus, [1, 2, 3])).to eq 6
    end

    it "send" do
      expect(CORELIB[:send].call("to_i", "01011101", 2)).to eq 93
    end
  end
end
