task :default => :build
task :build   => :gem

require 'rake/compiletask'
Rake::CompileTask.new

require 'rake/testtask'
Rake::TestTask.new do |t|
  t.pattern   = 'test/**/test_*.rb'
  t.ruby_opts = ['-rtest/helper']
  t.verbose   = true
end

require 'rubygems/package_task'
spec = Gem::Specification.load('hotcocoa.gemspec')
Gem::PackageTask.new(spec) { }

desc 'Install hotcocoa'
task :install => :gem do
  require 'rubygems/installer'
  Gem::Installer.new("pkg/#{spec.file_name}").install
end

# in reality this doesn't do the same dependency resolution that
# bundler is capable of, but this should be good 99% of the time
# and _way_ faster
desc 'Setup dependencies without* Bundler'
task :setup_dev do
  require 'rubygems/dependency_installer'
  (spec.runtime_dependencies + spec.development_dependencies).each do |dep|
    puts "Installing #{dep.name} (#{dep.requirement})"
    Gem::DependencyInstaller.new.install(dep.name, dep.requirement)
  end
end

desc 'Start up IRb with Hot Cocoa loaded'
task :console do
  irb = ENV['RUBY_VERSION'] ? 'irb' : 'macirb'
  sh "#{irb} -Ilib -rhotcocoa"
end

begin
  require 'yard'
  YARD::Rake::YardocTask.new
rescue LoadError
  warn 'yard not available. Install it with: macgem install yard'
end
