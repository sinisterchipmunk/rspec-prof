unless defined?(RSPEC_VERSION)
  begin
    # RSpec 1.3.0
    require 'spec'
    require 'spec/version'
    
    RSPEC_VERSION = Spec::VERSION::STRING
  rescue LoadError
    # RSpec 2.0
    begin
      require 'rspec/core'
      require 'rspec/core/version'
      
      RSPEC_VERSION = RSpec::Core::Version::STRING
    rescue LoadError
      raise "RSpec does not seem to be installed. You must gem install rspec to use this gem."
    end
  end
end
