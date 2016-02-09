require "lasp"
Lasp::load_stdlib!

def macroexpand(code)
  Lasp::execute("(macroexpand #{code})")
end

describe "stdmacros" do
  it "defm" do
    given    = macroexpand("(defm m (form) (reverse form))")
    expected = [:def, :m, [:macro, [:form], [:reverse, :form]]]
    expect(given).to eq expected
  end

  it "defn" do
    given    = macroexpand("(defn f (x) (+ 3 x))")
    expected = [:def, :f, [:fn, [:x], [:do, [:+, 3, :x]]]]
    expect(given).to eq expected
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

  it "macroexpand" do
    given    = macroexpand("(macroexpand (defn f (x) (+ 1 x)))")
    expected = [:apply, :defn, [:quote, [:f, [:x], [:+, 1, :x]]]]
    expect(given).to eq expected
  end
end
