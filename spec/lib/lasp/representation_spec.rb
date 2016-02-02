require "lasp/representation"

describe "representation" do
  it "overrides inspect to make it look more lispy" do
    expect([:fn, [1, 2, 3]].inspect).to eq "(fn (1 2 3))"
  end
end
