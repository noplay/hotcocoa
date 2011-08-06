# Overview

If you've done any amount of programming on Mac OS X, you know that
the API can be quite verbose. Even with MacRuby's wonderful keyword
arguments, it can be daunting to enter this...

    win = NSWindow.alloc.initWithContentRect [10,20,300,300],
      styleMask: (NSTitledWindowMask         |
                  NSClosableWindowMask       |
                  NSMiniaturizableWindowMask |
                  NSResizableWindowMask)

...every time you want to create and configure a new `NSWindow` instance!

This is the reason most developers use [Interface Builder](http://en.wikipedia.org/wiki/Interface_Builder)
to configure interface components.
The purpose of HotCocoa is to allow you to use the flexible syntax of
Ruby and its dynamic nature to simplify programmatically constructing
user interfaces on Mac OS X without an Interface Builder.

With HotCocoa, creating the `NSWindow` instance above is as simple as:

   win = window frame: [10,20,300,300]

HotCocoa achieves this feat by creating Mappings over the most common
Classes and Constants used on Mac OS X. Those mappings create
constructor methods on the HotCocoa module (like the "window" method
above). Each constructor method accepts an optional block which yields
the created instance (more on that in the
{file:docs/Tutorial.markdown HotCocoa Tutorial}). Mappings also
decorate the standard Objective-C API with nice Ruby APIs for
common operations. The important thing to realize is that the
constructor methods return real instances of these common classes, not
high-level abstractions. So, you can call any Objective-C method
available on those objects.

In HotCocoa, Mappings provide the following:

* Defaults: Smart default constructor parameters (like the styles in
  window) to minimize the parameters you have to pass in.
* Constants: Mapping of constants to Ruby symbols to minimize the text
  and maximize the readability of HotCocoa applications.
* Constructors: Building the instances of the mapped classes using the
  correct class-specific APIs.
* Custom Methods: Ruby-friendly API for commonly used methods (like
  `<<` for `addSubview` on 'NSView' subclasses).
* Delegate Methods: Simplified Ruby-friendly methods for delegating
  instances that use Ruby blocks

Now that you understand the basics of what HotCocoa is and why we are
building it, please look at
{file:docs/Resources.markdown HotCocoa Resources} (and eventually, the
{file:docs/Tutorial.markdown HotCocoa Tutorial}) for examples of how
to build Mac OS X applications with it. For a more detailed
understanding of how to read, create, edit, or contribute mapping
files, see {file:docs/Mappings.markdown HotCocoaMappings}. For the
current status of the project, visit the
[code repository](http://github.com/ferrous26/hotcocoa) on Github.
