require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "rspec-prof"
    gem.summary = %Q{Integrates ruby-prof with RSpec, allowing you to easily profile your RSpec examples.}
    gem.description = %Q{Integrates ruby-prof with RSpec, allowing you to easily profile your RSpec examples.}
    gem.email = "sinisterchipmunk@gmail.com"
    gem.homepage = "http://www.thoughtsincomputation.com/"
    gem.authors = ["Colin MacKenzie IV"]
    gem.add_dependency "sc-core-ext", ">= 1.2.1"
    gem.add_dependency "rspec"
    gem.add_dependency "ruby-prof"
    gem.add_development_dependency "jeweler", ">= 1.4.0"
    gem.add_development_dependency "rspec",   ">= 1.3.0"
    gem.add_development_dependency "builder", ">= 2.1.2"
    gem.files = FileList['**/*'] - FileList['profiles/**/*'] - FileList['pkg/**/*']
    gem.test_files = FileList['spec/**/*']
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
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

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "rspec-prof #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
