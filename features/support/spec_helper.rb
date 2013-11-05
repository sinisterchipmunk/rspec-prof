Before do |scenario|

  step 'a file named "spec/spec_helper.rb" with:', <<-end_file
    require 'simplecov'
    require 'coveralls'

    SimpleCov.start do
      root "#{File.expand_path('../..', File.dirname(__FILE__))}"
      coverage_dir 'coverage'
      SimpleCov.command_name #{scenario.title.inspect}
      filters.clear
      add_filter { |f| !f.filename['rspec-prof'] }
    end

    require 'rspec-prof'
  end_file

end
