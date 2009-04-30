# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{structr}
  s.version = "0.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = "Peter Suschlik"
  s.date = %q{2009-05-01}
  s.description = %q{Structure plain text.}
  s.email = %q{peter-structr@suschlik.de}
  s.files = [
    "CHANGELOG", "README.rdoc", "Rakefile",
    "lib/structr.rb"
  ]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/splattael/structr}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.summary = %q{Bind plain text to Ruby classes.}
end
