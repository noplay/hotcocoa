require 'hotcocoa/application/builder'

task :load_builder_from_appspec do
  appspec_files = FileList["#{Rake.application.original_dir}/*.appspec"]
  raise "No .appspec file found in your application directory!" if appspec_files.empty?
  raise "Multiple .appspec files found in your application directory! Only one should exist." if appspec_files.size > 1
  @builder = Application::Builder.new appspec_files.first
end

desc 'Build the application'
task :build => :load_builder_from_appspec do
  @builder.build
end

desc 'Build a deployable version of the application'
task :deploy => :load_builder_from_appspec do
  @builder.build deploy: true
end

desc 'Build and execute the application'
task :run => [:build] do
  @builder.run
end

desc 'Cleanup build files'
task :clean => :load_builder_from_appspec do
  @builder.remove_bundle_root
end

desc 'Create the dmg archive from the application bundle'
task :dmg => :deploy do
  app_name = @builder.spec.name
  rm_rf "#{app_name}.dmg"
  sh "hdiutil create #{app_name}.dmg -quiet -srcdir #{app_name}.app -format UDZO -imagekey zlib-level=9"
end
