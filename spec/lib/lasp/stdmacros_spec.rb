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

  it "macroexpand" do
    given    = macroexpand("(macroexpand (defn f (x) (+ 1 x)))")
    expected = [:apply, :defn, [:quote, [:f, [:x], [:+, 1, :x]]]]
    expect(given).to eq expected
  end
end
