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
      expected = [:apply, [:fn, [:x, :y], [:do, [:+, :x, :y]]], [:list, 1, 2]]
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

    it "does not allow an uneven number of bindings" do
      code = <<-LASP
        (let (one 1
              two 2
              three)
          (+ one two))
      LASP
      expect { Lasp::execute(code) }.to raise_error(Lasp::ArgumentError)
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
end
