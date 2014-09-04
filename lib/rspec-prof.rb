require 'fileutils'
require 'ruby-prof'
require 'rspec/core'
require 'rspec-prof/filename_helpers'

class RSpecProf
  extend FilenameHelpers

  @printer_class = RubyProf::GraphHtmlPrinter

  class << self
    attr_accessor :printer_class

    def profile filename
      profiler = new.start
      yield
    ensure
      profiler.save_to filename
    end
  end

  def start
    return if @profiling
    @profiling = true
    RubyProf.start
    self
  end

  def stop
    return unless @profiling
    @profiling = false
    @result = RubyProf.stop
  end

  def profiling?
    @profiling
  end

  def result
    @result
  end

  def save_to filename
    stop
    FileUtils.mkdir_p File.dirname(filename)
    File.open(filename, "w") do |f|
      printer = RSpecProf.printer_class.new(result)
      printer.print f
    end
  end
end

RSpec.configure do |config|
  config.before(:suite) do
    unless ['all', 'each', ''].include?(ENV['RSPEC_PROFILE'].to_s)
      raise "ENV['RSPEC_PROFILE'] should be blank, 'all' or 'each', but was '#{ENV['RSPEC_PROFILE']}'"
    end

    if ENV['RSPEC_PROFILE'] == 'all'
      @profiler = RSpecProf.new.start
    end
  end

  config.after(:suite) do
    if ENV['RSPEC_PROFILE'] == 'all'
      @profiler.save_to  "profiles/all.html"
    end
  end

  config.around(:each) do |example|
    if ENV['RSPEC_PROFILE'] == 'each'
      RSpecProf.profile(RSpecProf.filename_for(example)) { example.call }
    else
      example.call
    end
  end
end
