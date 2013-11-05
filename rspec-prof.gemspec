# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "rspec-prof"
  s.version = "0.0.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Colin MacKenzie IV"]
  s.date = "2011-11-04"
  s.description = "Integrates ruby-prof with RSpec, allowing you to easily profile your RSpec examples."
  s.email = "sinisterchipmunk@gmail.com"
  s.extra_rdoc_files = [
    "LICENSE",
    "README.rdoc"
  ]
  s.files = `git ls-files`.split("\n")
  s.homepage = "http://www.thoughtsincomputation.com/"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.10"
  s.summary = "Integrates ruby-prof with RSpec, allowing you to easily profile your RSpec examples."
  s.test_files = `git ls-files -- spec/`

  s.add_runtime_dependency 'rspec'
  s.add_runtime_dependency 'ruby-prof'
  s.add_development_dependency 'cucumber'
  s.add_development_dependency 'aruba'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'coveralls'
  s.add_development_dependency 'rake'
end

