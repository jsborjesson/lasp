require "spec_helper"
require "lasp"
require "lasp/env"

describe Lasp do
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

    it "makes a __FILE__ variable available while executing a file" do
      env = Lasp::env_with_corelib

      with_tempfile('__FILE__') do |file|
        expect(Lasp::execute_file(file.path, env)).to match /.lasp/
      end

      # __FILE__ has to go out of scope when the file has finished execution
      expect(Lasp::execute('__FILE__', env)).to eq nil
    end
  end
end
