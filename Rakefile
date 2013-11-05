begin
  require 'bundler'
  Bundler::GemHelper.install_tasks
  Bundler.setup
rescue LoadError
  puts " *** You don't seem to have Bundler installed. ***"
  puts "     Please run the following command:"
  puts
  puts "       gem install bundler"
  raise "bundler is not installed"
end

require 'coveralls/rake/task'
Coveralls::RakeTask.new

require 'cucumber/rake/task'
Cucumber::Rake::Task.new :cucumber
task :default => [:cucumber, 'coveralls:push']
