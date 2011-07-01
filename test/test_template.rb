require 'fileutils'
require 'hotcocoa/template'

class TestHotCocoaTemplate < MiniTest::Unit::TestCase

  def setup
    @dir = File.join(File.dirname(__FILE__), 'template_test')
    HotCocoa::Template.copy_to @dir, 'AWESOME SAUCE'
  end

  def teardown
    FileUtils.rm_rf @dir
  end

  def all_files_in dir
    Dir.glob(File.join(dir, '**', '*'))
  end

  def test_source_directory_is_correct
    what_git_thinks      = `git rev-parse --show-toplevel`.chomp
    what_hotcocoa_thinks = HotCocoa::Template.source_directory
    assert_equal what_git_thinks, what_hotcocoa_thinks
  end

  def test_copy_to_substitutes_app_name_properly
    content = ''
    all_files_in(@dir).each do |file|
      next if File.extname(file) == '.icns'
      next if File.directory? file
      content << IO.read(file)
    end
    refute_match /__APPLICATION_NAME__/, content
    assert_match /AWESOME SAUCE/, content
  end

  def test_copy_to_copies_everything
    source_dir = `git rev-parse --show-toplevel`.chomp
    from       = all_files_in(File.join(source_dir, 'template'))
    from.map! { |file| file.sub /^#{File.join(source_dir, 'template')}/, '' }
    to         = all_files_in(@dir)
    to.map! { |file| file.sub /^#{@dir}/, '' }
    assert_empty to - from
  end

end
