require "bundler/gem_tasks"

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)
task :default => :spec

desc "Install and laund the Läsp REPL"
task :repl => [:install] do
  sh "lasp"
end
