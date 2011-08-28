task :default => :build
task :build   => :gem

if MACRUBY_REVISION.match(/^git commit/)
  require 'rake/compiletask'
  Rake::CompileTask.new do |t|
    t.files   = FileList['lib/**/*.rb']
    t.verbose = true
  end

  desc 'Clean MacRuby binaries'
  task :clean do
    FileList['lib/**/*.rbo'].each do |bin|
      $stdout.puts "rm #{bin}"
      rm bin
    end
  end
end

require 'rake/testtask'
Rake::TestTask.new do |t|
  t.pattern   = 'test/**/test_*.rb'
  t.ruby_opts = ['-rtest/helper']
  t.verbose   = true
end

require 'rake/gempackagetask'
spec = Gem::Specification.load('hotcocoa.gemspec')
Rake::GemPackageTask.new(spec) { }

require 'rubygems/dependency_installer'
desc 'Install hotcocoa'
task :install => :gem do
  Gem::Installer.new("pkg/#{spec.file_name}").install
end

# in reality this doesn't do the same dependency resolution that
# bundler is capable of, but this should be good 99% of the time
# and _way_ faster
desc 'Setup dependencies without* Bundler'
task :setup_dev do
  (spec.runtime_dependencies + spec.development_dependencies).each do |dep|
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
