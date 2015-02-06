# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "structr/version"

Gem::Specification.new do |s|
  s.name        = "structr"
  s.version     = Structr::VERSION
  s.authors     = ["Peter Suschlik"]
  s.email       = ["peter-structr@suschlik.de"]
  s.homepage    = "http://rubygems.org/gems/structr"
  s.summary     = "Parse plain text to Ruby classes."

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rake"
  s.add_development_dependency "rdoc"
  s.add_development_dependency "minitest"
end
