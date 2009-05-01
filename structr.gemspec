# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{structr}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Peter Suschlik"]
  s.date = %q{2009-05-01}
  s.description = %q{Bind plain text to Ruby classes.}
  s.email = %q{peter-structr@suschlik.de}
  s.extra_rdoc_files = ["CHANGELOG", "lib/structr.rb", "README.rdoc"]
  s.files = ["Rakefile", "examples/invoice.rb", "examples/top.rb", "CHANGELOG", "lib/structr.rb", "README.rdoc", "structr.gemspec", "Manifest", "test/test_structr.rb", "test/test_field_descriptor.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/splattael/structr}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Structr", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{structr}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Bind plain text to Ruby classes.}
  s.test_files = ["test/test_structr.rb", "test/test_field_descriptor.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
