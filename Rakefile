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

unless defined?(RSPEC_VERSION)
  begin
    # RSpec 1.3.0
    require 'spec/rake/spectask'
    require 'spec/version'
    
    RSPEC_VERSION = Spec::VERSION::STRING
  rescue LoadError
    # RSpec 2.0
    begin
      require 'rspec/core/rake_task'
      require 'rspec/core/version'
      
      RSPEC_VERSION = RSpec::Core::Version::STRING
    rescue LoadError
      raise "RSpec does not seem to be installed. You must gem install rspec to use this gem."
    end
  end
end

if RSPEC_VERSION >= "2.0.0"
  RSpec::Core::RakeTask.new(:spec) do |spec|
    spec.pattern = 'spec/**/*_spec.rb'
  end
else # Rake task for 1.3.x
  Spec::Rake::SpecTask.new(:spec) do |spec|
    spec.libs << 'lib' << 'spec'
    spec.spec_files = FileList['spec/**/*_spec.rb']
  end

  Spec::Rake::SpecTask.new(:rcov) do |spec|
    spec.libs << 'lib' << 'spec'
    spec.pattern = 'spec/**/*_spec.rb'
    spec.rcov = true
  end
end

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "rspec-prof #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
