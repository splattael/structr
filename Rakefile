require 'bundler/gem_tasks'
require 'rake'

desc 'Default: run specs.'
task :default => :spec

require 'rake/testtask'
Rake::TestTask.new(:spec) do |test|
  test.test_files = FileList.new('spec/*_spec.rb')
  test.libs << 'spec'
  test.verbose = true
end

require 'rdoc/task'
Rake::RDocTask.new do |rd|
  rd.title = "Parse plain text with Ruby classes"
  rd.main = "README.rdoc"
  rd.rdoc_files.include("README.rdoc", "lib/*.rb")
  rd.rdoc_dir = "doc"
end

desc "Tag files for vim"
task :ctags do
  dirs = $LOAD_PATH.select {|path| File.directory?(path) }
  system "ctags -R #{dirs.join(" ")}"
end

desc "Find whitespace at line ends"
task :eol do
  system "grep -nrE ' +$' *"
end
