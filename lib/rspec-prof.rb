unless defined?(Gem)
  require 'rubygems'
  gem 'sc-core-ext', ">= 1.2.1"
  gem 'rspec'
  gem 'ruby-prof'
end

require 'sc-core-ext'
require 'ruby-prof'
require 'ftools'

begin
  require 'spec'
rescue LoadError
  raise "Implement me: support for rspec >= 2.0 not yet available"
end

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
      (
        "#{$rspec_prof_filename_id += 1}-" +
        self.class.description_parts.join(" ") +
        " #{description}").gsub(/\s+/, '_'
      ).gsub(/\(profiling\)/, '')
    end
  end
  
  module ClassMethods
    # Sets up a profiling context. All specs within this context will be profiled. You can pass a scope of
    # :each or :all. A scope of :each will cause each contained spec to be profiled independently of any others;
    # a scope of :all will profile all specs at once and produce a net result. You can also pass some options:
    # see RSpecProf::Profiler for information on those.
    def profile(scope = :each, options = {}, &block)
      if scope.kind_of?(Hash)
        options.reverse_merge! scope
        scope = :each
      end
      
      context "(profiling)" do
        before(scope) do
          raise "Cannot start profiling because a profiler is already active" if @profiler
          if Thread.current.object_id == $rspec_prof_thread_id
            @profiler = RSpecProf::Profiler.new(options.reverse_merge(:file => default_filename))
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

Spec::Runner.configure do |config|
  config.extend RSpecProf::ClassMethods
  config.include RSpecProf::InstanceMethods
end

Spec::Example::ExampleGroupMethods.send(:include, RSpecProf::ClassMethods)
Spec::Example::ExampleMethods.send(:include, RSpecProf::InstanceMethods)
