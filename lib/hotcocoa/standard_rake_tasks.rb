$stderr.puts <<EOM
standard_rake_tasks.rb is deprecated in favour of a new app template
which declares the tasks directly in the template Rakefile.

You can update your Rakefile by copying the new tasks from Github at
https://github.com/ferrous26/hotcocoa/blob/master/template/Rakefile
EOM

AppConfig = HotCocoa::ApplicationBuilder::Configuration.new( 'config/build.yml' )

desc 'Build a deployable version of the application'
task :deploy do
  HotCocoa::ApplicationBuilder.build AppConfig, deploy: true
end

desc 'Build the application'
task :build do
  HotCocoa::ApplicationBuilder.build AppConfig
end

desc 'Build and execute the application'
task :run => [:build] do
  `"./#{AppConfig.name}.app/Contents/MacOS/#{AppConfig.name.gsub(/ /, '')}"`
end

desc 'Cleanup build files'
task :clean do
  sh "/bin/rm -rf '#{AppConfig.name}.app'"
end
