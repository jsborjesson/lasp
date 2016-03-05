require "spec_helper"
require "lasp"

module Lasp
  describe "execute" do
    it "executes plain text code" do
      expect(Lasp::execute("(+ 10 15)")).to eq 25
    end
  end

  describe "execute_file" do
    it "executes lasp-files" do
      with_tempfile("(+ 10 15)") do |file|
        expect(Lasp::execute_file(file.path)).to eq 25
      end
    end

    it "wraps files in a do-block" do
      with_tempfile('(+ "fi" "rst") (+ "la" "st")') do |file|
        expect(Lasp::execute_file(file.path)).to eq "last"
      end
    end
  end
end
