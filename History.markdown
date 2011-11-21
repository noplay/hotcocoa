# Release History

## 0.7.0 ????-??-??

* Enhancements:
  + Removed old application builder
  + Bridgesupport embedding enabled by default for new projects
  + Deprecated Range#to_NSRange in favour of Range#relative_to
  + Deprecated Numeric#negative?
  + Deprecated Object#full_const_get
  + Deprecated NSArray#second
  + Deprecated NSArray#third
  + Moved some NSMutableAttributedString extensions to NSAttributedString
  + Requires MacRuby 0.11+
  + Revamped the documentation
* New mappings:
  + matrix => NSMatrix

## 0.6.0 2011-10-14

* 10 enhancements:
  + New application builder to work with MacRuby 0.11
  + Old application builder is deprecated
  + New application templates now use an appspec, similar to a gemspec
  + config.yml is now deprecated
  + Lazier loading for mappings (may break custom mappings!)
  + API documention (~67% coverage so far)
  + Regression tests (< 67% coverage so far)
  + Updating and porting of the tutorial documentation (~40% complete)
  + HotCocoa now works when compiled (HotCocoa will boot ~2.5 faster)
  + HotCocoa is now leaner
  + Various bug fixes

* 4 new mappings:
  + bonjour_service => NSNetService
  + bonjour_browser => NSNetServiceBrowser
  + line           => NSBezierPath
  + tracking_area  => NSTrackingArea

* 2 graphics improvements:
  + Image class works with more image types
  + Image class can save images

## 0.0.1 2009-11-07

* 1 major enhancement:
  + Initial release
