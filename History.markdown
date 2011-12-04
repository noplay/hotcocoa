# Release History

## 0.6.1 2011-12-4

* Enhancements:
  * Bridgesupport embedding now enabled by default for new projects
  * Ensure that the short version is set in an app bundles Info.plist
  * Begin overhauling the documentation
  * Better error handling for the DelegateBuilder

* Fixes:
  * Fixed some UI glitches with the Demo app
  * The application builder now sets the copyright string in an app bundles Info.plist
  * DelegateBuilder no longer crashes when parameters were given as Symbols

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
