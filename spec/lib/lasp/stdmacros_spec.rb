require "lasp"

describe "stdmacros" do
  let(:env) { Lasp.env_with_stdlib }

  def macroexpand(program)
    execute("(macroexpand #{program})")
  end

  def execute(program)
    Lasp.execute(program, env)
  end

  describe "defm" do
    it "produces the expected form" do
      given    = macroexpand("(defm m (form) (reverse form))")
      expected = [:def, :m, [:macro, [:form], [:reverse, :form]]]
      expect(given).to eq expected
    end

    it "creates a named macro" do
      execute("(defm test-macro (x) x)")
      expect(execute("test-macro").inspect).to eq "#<Macro test-macro (x)>"
    end
  end

  describe "defn" do
    it "produces the expected form" do
      given    = macroexpand("(defn f (x) (+ 3 x))")
      expected = [:def, :f, [:fn, [:x], [:do, [:+, 3, :x]]]]
      expect(given).to eq expected
    end

    it "creates a named function" do
      execute("(defn test-fn (x) x)")
      expect(execute("test-fn").inspect).to eq "#<Fn test-fn (x)>"
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
      expect(execute(code)).to eq 3
    end

    it "sets an empty binding to nil" do
      code = <<-LASP
        (let (one 1
              two 2
              three)
          (+ one two)
          three)
      LASP
      expect(execute(code)).to eq nil
    end

    it "allows access to previous bindings" do
      code = <<-LASP
        (let (one 1
              two (+ one 1))
          two)
      LASP

      expect(execute(code)).to eq 2
    end

    it "takes the bindings out of scope as soon as the let ends" do
      code = <<-LASP
        (do
          (let (one 1))
          (println one))
      LASP
      expect { execute(code) }.to raise_error(Lasp::NameError, /one/)
    end
  end

  describe "macroexpand" do
    it "produces the expected form" do
      given    = macroexpand("(macroexpand (defn f (x) (+ 1 x)))")
      expected = [:apply, :defn, [:quote, [:f, [:x], [:+, 1, :x]]]]
      expect(given).to eq expected
    end

    it "returns the unevaluated result of a macro" do
      form = execute("(macroexpand (defn test-fn (x) x))")
      expect(form).to eq [:def, :"test-fn", [:fn, [:x], [:do, :x]]]
    end
  end

  describe "or" do
    it "returns nil when given no arguments" do
      expect(execute("(or)")).to eq nil
    end

    it "returns the last value if no truthy values are present" do
      expect(execute("(or nil nil false)")).to eq false
    end

    it "returns the first truthy value it valuates" do
      expect(STDOUT).not_to receive(:print)
      expect(execute('(or (not true) 42 (println "nope"))')).to eq 42
    end
  end

  describe "and" do
    it "returns true when given no arguments" do
      expect(execute("(and)")).to eq true
    end

    it "returns the last value if no falsy values are present" do
      expect(execute("(and true true 42)")).to eq 42
    end

    it "returns the first falsy value it valuates" do
      expect(STDOUT).not_to receive(:print)
      expect(execute('(and 42 false (println "nope"))')).to eq false
    end
  end
end
