require "bundler/gem_tasks"

# rake spec
require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec)

# rake style
require "rubocop/rake_task"
RuboCop::RakeTask.new(:style)

task default: [:spec, :style]

desc "Install and launch the Läsp REPL"
task repl: [:install] do
  sh "lasp"
end
