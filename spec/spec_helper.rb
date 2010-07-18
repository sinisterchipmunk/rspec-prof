$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require File.join(File.dirname(__FILE__), "../lib/rspec-prof")

if RSPEC_VERSION >= "2.0.0"
  require 'rspec/autorun'
else
  require 'spec/autorun'
end
