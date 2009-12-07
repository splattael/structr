require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :test

require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name = "structr"
  gem.summary = 'Parse plain text to Ruby classes.'
  gem.email = "peter-structr@suschlik.de"
  gem.homepage = "http://github.com/splattael/structr"
  gem.authors = ["Peter Suschlik"]

  gem.has_rdoc = true
  gem.extra_rdoc_files = [ "README.rdoc" ]

  gem.add_development_dependency "riot", ">= 0.10.4"
  gem.add_development_dependency "riot_notifier", ">= 0.0.5"

  gem.test_files = Dir.glob('test/test_*.rb')
end

Jeweler::GemcutterTasks.new

# Test
require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.test_files = FileList.new('test/test_*.rb')
  test.libs << 'test'
  test.verbose = true
end

namespace :test do
  desc "Run all tests on multiple ruby versions (requires rvm)"
  task(:portability) do
    %w(system 1.8.6 1.8.7 1.9.1 1.9.2 ree jruby).each do |version|
      system <<-BASH
        bash -c 'source ~/.rvm/scripts/rvm;
        rvm #{version};
        echo "--------- v#{version} ----------\n";
        rake -s test'
      BASH
    end
  end
end

# RDoc
Rake::RDocTask.new do |rd|
  rd.title = "Parse plain text with Ruby classes"
  rd.main = "README.rdoc"
  rd.rdoc_files.include("README.rdoc", "lib/*.rb")
  rd.rdoc_dir = "doc"
end


# Misc
desc "Tag files for vim"
task :ctags do
  dirs = $LOAD_PATH.select {|path| File.directory?(path) }
  system "ctags -R #{dirs.join(" ")}"
end

desc "Find whitespace at line ends"
task :eol do
  system "grep -nrE ' +$' *"
end
