unless defined?(Gem)
  require 'rubygems'
  gem 'rspec'
  gem 'ruby-prof'
end

require 'ruby-prof'
require 'fileutils'

require File.join(File.dirname(__FILE__), "rspec")
require 'rspec-prof/profiler'
$rspec_prof_filename_id = 0
$rspec_prof_thread_id = Thread.current.object_id

# See the README for general usage information.
#
# See RSpecProf::Profiler for all configuration options.
#
# You can enable RSpecProf by adding
#   RSpecProf.enable!
# to your spec_helper.rb file. Actually, RSpecProf is enabled by default.
#
# You can disable RSpecProf by adding
#   RSpecProf.disable!
# to your spec_helper.rb file.
#
# You can see if RSpecProf is enabled by calling
#   RSpecProf.enabled?
#
module RSpecProf
  class << self
    # Enables all profiling
    def enable!
      @enabled = true
    end
    
    # Disables all profiling with RSpecProf
    def disable!
      @enable = false
    end
    
    # Returns true if profiling is enabled, false otherwise.
    def enabled?
      @enabled ||= true
    end
  end
  
  module InstanceMethods
    # Returns a unique filename for this example group, based on the total description and a unique identifier.
    def default_filename
      if RSPEC_VERSION >= "2.0.0"
        description = self.example.to_s
        description = self.class.ancestors.collect { |a| a.description }.reverse.join(" ") if 
			(description.nil? || description.empty?)
        puts description
        (
          "#{$rspec_prof_filename_id += 1}-" +
          description
        ).gsub(/\s+/, '_').gsub(/\(profiling\)/, '')
      else
        (
          "#{$rspec_prof_filename_id += 1}-" +
          self.class.description_parts.join(" ") +
          " #{self.description}"
        ).gsub(/\s+/, '_').gsub(/\(profiling\)/, '')
      end
    end
  end
  
  module ClassMethods
    # Sets up a profiling context. All specs within this context will be profiled. You can pass a scope of
    # :each or :all. A scope of :each will cause each contained spec to be profiled independently of any others;
    # a scope of :all will profile all specs at once and produce a net result. You can also pass some options:
    # see RSpecProf::Profiler for information on those.
    def profile(scope = :each, options = {}, &block)
      if scope.kind_of?(Hash)
        options = scope.merge( options )
        scope = :each
      end
      
      context "(profiling)" do
        before(scope) do
          raise "Cannot start profiling because a profiler is already active" if @profiler
          if Thread.current.object_id == $rspec_prof_thread_id
            options[:file] ||= default_filename
            @profiler = RSpecProf::Profiler.new(options)
            @profiler.start
          else
            Kernel.warn "Profiling is disabled because you appear to be multi-threading the specs"
          end
        end
        
        instance_eval &block
        
        after(scope) do
          @profiler.stop if @profiler
          @profiler = nil
        end
      end
    end
  end
end

if RSPEC_VERSION >= "2.0.0"
  RSpec.configure do |config|
    config.extend RSpecProf::ClassMethods
    config.include RSpecProf::InstanceMethods
  end

  #RSpec::Core::ExampleGroup.send(:include, RSpecProf::ClassMethods)
  #RSpec::Core::Example.send(:include, RSpecProf::InstanceMethods)
else
  Spec::Runner.configure do |config|
    config.extend RSpecProf::ClassMethods
    config.include RSpecProf::InstanceMethods
  end
  
  Spec::Example::ExampleGroupMethods.send(:include, RSpecProf::ClassMethods)
  Spec::Example::ExampleMethods.send(:include, RSpecProf::InstanceMethods)
end
