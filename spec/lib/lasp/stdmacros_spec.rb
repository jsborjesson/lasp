require "lasp"
Lasp::load_stdlib!

def macroexpand(code)
  Lasp::execute("(macroexpand #{code})")
end

describe "stdmacros" do
  describe "defm" do
    it "produces the expected form" do
      given    = macroexpand("(defm m (form) (reverse form))")
      expected = [:def, :m, [:macro, [:form], [:reverse, :form]]]
      expect(given).to eq expected
    end

    it "creates a named macro" do
      Lasp::execute("(defm test-macro (x) x)")
      expect(Lasp::execute("test-macro").inspect).to eq "#<Macro (x)>"
    end
  end

  describe "defn" do
    it "produces the expected form" do
      given    = macroexpand("(defn f (x) (+ 3 x))")
      expected = [:def, :f, [:fn, [:x], [:do, [:+, 3, :x]]]]
      expect(given).to eq expected
    end

    it "creates a named function" do
      Lasp::execute("(defn test-fn (x) x)")
      expect(Lasp::execute("test-fn").inspect).to eq "#<Fn (x)>"
    end
  end

  describe "let" do
    it "produces the expected form" do
      given    = macroexpand("(let (x 1 y 2) (+ x y))")
      expected = [[:fn, [:x], [[:fn, [:y], [:do, [:+, :x, :y]]], 2]], 1]
      expect(given).to eq expected
    end

    it "creates local bindings" do
      code = <<-LASP
        (let (one 1
              two (+ 1 1))
          (+ one two))
      LASP
      expect(Lasp::execute(code)).to eq 3
    end

    it "sets an empty binding to nil" do
      code = <<-LASP
        (let (one 1
              two 2
              three)
          (+ one two)
          three)
      LASP
      expect(Lasp::execute(code)).to eq nil
    end

    it "allows access to previous bindings" do
      code = <<-LASP
        (let (one 1
              two (+ one 1))
          two)
      LASP

      expect(Lasp::execute(code)).to eq 2
    end

    it "takes the bindings out of scope as soon as the let ends" do
      code = <<-LASP
        (do
          (let (one 1))
          (println one))
      LASP
      expect { Lasp::execute(code) }.to raise_error(Lasp::NameError, /one/)
    end
  end

  describe "macroexpand" do
    it "produces the expected form" do
      given    = macroexpand("(macroexpand (defn f (x) (+ 1 x)))")
      expected = [:apply, :defn, [:quote, [:f, [:x], [:+, 1, :x]]]]
      expect(given).to eq expected
    end

    it "returns the unevaluated result of a macro" do
      form = Lasp::execute("(macroexpand (defn test-fn (x) x))")
      expect(form).to eq [:def, :"test-fn", [:fn, [:x], [:do, :x]]]
    end
  end

  describe "or" do
    it "returns nil when given no arguments" do
      expect(Lasp::execute("(or)")).to eq nil
    end

    it "returns the last value if no truthy values are present" do
      expect(Lasp::execute('(or nil nil false)')).to eq false
    end

    it "returns the first truthy value it valuates" do
      expect(STDOUT).not_to receive(:print)
      expect(Lasp::execute('(or (not true) 42 (println "nope"))')).to eq 42
    end
  end
end
