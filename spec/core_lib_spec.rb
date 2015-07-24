require "./lib/core_lib"

describe CORE_LIB do
  it "+" do
    expect(CORE_LIB[:+].(1, 2, 3)).to eq 6
  end

  it "-" do
    expect(CORE_LIB[:-].(1, 2, 3)).to eq -4
  end

  it "*" do
    expect(CORE_LIB[:*].(2, 3, 4)).to eq 24
  end

  it "*" do
    expect(CORE_LIB[:/].(20, 2, 2)).to eq 5
  end
end
