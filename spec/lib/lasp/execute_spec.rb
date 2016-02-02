require "lasp"
require "tempfile"

module Lasp
  describe "execute" do
    it "executes plain text code" do
      expect(Lasp::execute("(+ 10 15)")).to eq 25
    end

    it "executes lasp-files" do
      Tempfile.open("lasp-test") do |file|
        file.write("(+ 10 15)")
        file.rewind

        expect(Lasp::execute_file(file.path)).to eq 25
      end
    end

    it "wraps files in a do-block" do
      Tempfile.open("lasp-test") do |file|
        file.write('(+ "fi" "rst") (+ "la" "st")')
        file.rewind

        expect(Lasp::execute_file(file.path)).to eq "last"
      end
    end
  end
end
