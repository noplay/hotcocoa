# HotCocoa Manual

HotCocoa is a thin, idiomatic Ruby layer that sits above Cocoa and other frameworks. The goal of the project is to simplify the process of creating
and configuring Cocoa objects used when building native Mac apps.

## Creating your first app

### Prerequisites

1. You will need the Mac OS X developer tools in order
to build apps. Xcode is not required, but the compiler toolchain is
needed.

2. Mac OS X 10.6+. If you are on Snow Leopard, you will also need the
[Bridge Support Preview v3](http://www.macruby.org/files/BridgeSupport%20Preview%203.zip)
in order to run HotCocoa. Read about it on the
[MacRuby Blog](http://www.macruby.org/blog/2010/10/08/bridgesupport-preview.html). Lion users do not need to install this.

### Getting up and running

Install hotcocoa from `rubygems.org`:

    $ sudo macgem install hotcocoa

Generate the app scaffolding:

    $ hotcocoa my_first_app

Start the app:

    $ cd my_first_app
    $ macrake run

## Mappings: an alternative to IB

### Overview

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
  `#<<` for `#addSubview` on `NSView` subclasses).
* Delegate Methods: Simplified Ruby-friendly methods for delegating
  instances that use Ruby blocks

A HotCocoa mapping defines a structure that sits on top of a
particular Objective-C class and simplifies its usage in MacRuby.

This structure is defined in a simple, Ruby-based
[DSL](http://en.wikipedia.org/wiki/Domain-specific_language)
(domain-specific language).  The HotCocoa DSL includes syntax to aid in
object instantiation, constant mapping, default options, customized
methods, and delegate-method mappings.  The only required section is
object instantiation; the other four sections are only required if the
Objective-C class in question requires it.  Once defined, a mapping is
registered with the {#HotCocoa::Mappings} module, using the names of
the mapping and the mapped Objective-C class.

The mappings that ship with HotCocoa are found in the
'lib/hotcocoa/mappings' directory of the source.  You can easily define
your own mappings for classes by following the examples below.  Place
mappings in files of your own, loading them after you load the
`hotcocoa` library.

### Basic Mapping Syntax

The basic syntax for defining a mapping is:

    HotCocoa::Mappings.map name: CocoaClassName do
      # mapping code...
    end

To create a mapping, call the `map` method on `HotCocoa::Mappings`,
passing in a key-value pair to specify the constructor name and Cocoa
class to be mapped.  Replace `name:` with the desired name of the method
you want to be generated and made available to users of HotCocoa.  For
example, the mapping definition for an `NSButton` might be:

    HotCocoa::Mappings.map button: NSButton do
      # mapping code...
    end

This creates a method on HotCocoa named `button`, which will return
an instance of an `NSButton` class.  One caveat to note now is that
the class being mapped has to be available when you define the
mapping. `NSButton` is available because HotCocoa loads the `Cocoa`
framework; if you want to map a class from `AVFoundation` then you
will need to load `AVFoundation` before you define any mappings.

You can create more than one mapping per Objective-C class.  A good
reason to do this would be to provide different sets of defaults. As
an example,
[Interface Builder](http://en.wikipedia.org/wiki/Interface_Builder)
provides several "different" types of buttons in its Object Library,
but they are all instances of `NSButton` that just have a different
default configuration.

### Object Instantiation Method (required)

There are two methods, `#init_with_options` and `#alloc_with_options`,
that you can implement to support object instantiation. Define these
methods within the block that you pass to the `map` method.

    HotCocoa::Mappings.map button: NSButton do
      def init_with_options buttons, options
        button.initWithFrame options.delete(:frame)
      end
    end

As you can see from the method definition above, the
`#init_with_options` method is provided with an instance of the class
that you declared in the mapping (`NSButton`) which is created with
`NSButton.alloc`. This implementation just calls the proper `#init`
method. This example calls `#initWithFrame` and passes the options
value for the `:frame`. The options hash is passed to this function
when you call the `#button` method:

    button frame: [0,0,20,100]

Note that the method must delete any option that it consumes and must
return the mapped object. Every option used in the construction of the
object should be removed from the hash. Any options that are left in the hash
after begin processed by the instantiation methods will be dispatched
to the `NSButton` instance.

The second method you can implement is:

    HotCocoa::Mappings.map button: NSButton do
      def alloc_with_options options
        NSButton.alloc.initWithFrame options.delete(:frame)
      end
    end

Here you are not provided with the `alloc`'d object as the first
parameter, but simply the options hash. This is helpful for classes
that use class methods for instantiation, such as:

    NSImage.imageNamed 'my_image'

You should implement either `#init_with_options` or
`#alloc_with_options`, but not both. If `#alloc_with_options` exists,
it will be called and `#init_with_options` will be ignored.

If you want a constructor to handle a block with extra behavior then
you will also need to implement `#handle_block` for the mapping. Block
handling is done after the mapped instance has been initialized and
`#handle_block` will be given the instance as a parameter. For
instance, HotCocoa uses this construct to encapsulate normal
application setup:

    HotCocoa::Mappings.map application: NSApplication do
      def alloc_with_options opts
        NSApplication.sharedApplication
      end
      def handle_block app
        load_menus
        yield application
        application.run
      end
    end

    HotCocoa.application do |app|
      app.delegate = self
    end

### Default Options (optional)

You can provide a hash of default options in the definition of your
mapping. This is very useful for many Cocoa classes, because there are
so many configuration options. Defaults are appended to the options
hash that is passed into the constructor method if a value of the same
key does not exist.

Supplying your defaults is simple. In the example below, if you
provide a `:frame`, it will be used instead of `CGRectZero`:

    HotCocoa::Mappings.map button: NSButton do
      defaults bezel: :rounded,
               frame: CGRectZero,
              layout: {}
    end

A few of the defaults shown above are pretty important to UI classes;
specifically, `:frame` and `:layout`. The `NSButton` example uses
`frame: CGRectZero`. The `CGRectZero` constant equals a rectangle of
`[0,0,0,0]`. The `layout: {}` part is important for using the
`layout_view` classes, which are included in HotCocoa, it describes
where to put the UI element.

This default value for the layout is an empty hash, but if it's not
passed, the default value  for the layout is actually `nil`. If the
layout is `nil`, the component is not included when the `layout_view`
computes the layout for the components. All of the UI mappings that ship with
HotCocoa provide an empty hash as a default `:layout`.

### Constant Mapping (optional, inherited)

Because constant names need to be globally unique in Objective-C, they
can get very long. What the constant mapping provides in HotCocoa is
the ability to use short symbol names and map them to the constant
names that are scoped to the wrapped class. This is an example of
mapping constants to represent button state:

    HotCocoa::Mappings.map button: NSButton do
      constant :state, {
        on:    NSOnState,
        off:   NSOffState,
        mixed: NSMixedState
      }
    end

A constant map includes the key (`:state`), followed by a hash which
maps symbols to actual constants. When you provide options to the
constructor method that match a constant key, it looks up the
corresponding value in that hash and replaces the value in the option
hash with the constant's value.

So, when you call:

    button :state => :on

It will be replaced with:

    button :state => NSOnState

You can have as many constant maps in each class as you need. Constant
maps are also inherited by subclasses. A constant map on `NSView` is
also available on `NSControl` and `NSButton` (as they are subclasses).

If you provide a value for a constant key that is an array rather than
a single symbol, the constants in the array are __OR__'d with each
other. This is useful when the constants are masked. For `NSWindow`'s
mapping of style:

    { style: [:titled, :closable, :miniaturizable, :resizable] }

is equivalent to:

    style = NSTitledWindowMask         |
            NSClosableWindowMask       |
            NSMiniaturizableWindowMask |
            NSResizableWindowMask

### Custom Methods (optional, inherited)

Custom methods are simply modules that are included in the instance;
they provide idiomatic Ruby methods for the mapped Objective-C class
instance. Providing custom methods in your mapping is easy:

    HotCocoa::Mappings.map button: NSButton do
      custom_methods do
        def bezel= value
          setBezelStyle(value)
        end
        def on?
          state == NSOnState
        end
      end
    end

In the first method, `#bezel=`, we provide a better method name than
`setBezelStyle`. Although we could provide idiomatic Ruby methods for
every Objective-C method, the number of these methods is huge. The
general principle is to customize where this provides something
better, not just syntactically better. Custom methods, like constant
mappings, are inherited by subclasses.

### Constant Mappings and Custom Methods

In the last example, the `#bezel=` method serves as a corresponding
method name to the constant map for bezel style:

    constant :bezel, {
      rounded:            NSRoundedBezelStyle,
      regular_square:     NSRegularSquareBezelStyle,
      thick_square:       NSThickSquareBezelStyle,
      thicker_square:     NSThickerSquareBezelStyle,
      disclosure:         NSDisclosureBezelStyle,
      shadowless_square:  NSShadowlessSquareBezelStyle,
      circular:           NSCircularBezelStyle,
      textured_square:    NSTexturedSquareBezelStyle,
      help_button:        NSHelpButtonBezelStyle,
      small_square:       NSSmallSquareBezelStyle,
      textured_rounded:   NSTexturedRoundedBezelStyle,
      round_rect:         NSRoundRectBezelStyle,
      recessed:           NSRecessedBezelStyle,
      rounded_disclosure: NSRoundedDisclosureBezelStyle
    }

This way, you can easily create buttons of the provided bezel style:

    button :bezel => :circular

If you recall from the default options section (above), you can also
include default values that are constant mapped values (e.g.
`:bezel => :rounded` is the default for a button). In this way,
constant mappings and custom methods work together to provide a vastly
better syntax for using constants in your code and simplifying the
code needed for an `#init_with_options` method.

### Delegate Method Mapping (optional)

Delegate method mapping is a little more complex then the prior
sections. Delegate methods are used pervasively in Cocoa to facilitate
customization of controls. Normally, what you need to do is implement
the methods that the control is looking for in a class of your
own. You would then set an instance of that class as the delegate of
the control, using `setDelegate(instance)`.

In HotCocoa, we wanted to enable the use of Ruby blocks for delegate
method calls, so the Objective-C code:

    class MyDelegate
      def windowWillClose sender
        # perform something
      end
    end

    window.setDelegate(MyDelegate.new)

is simplified to the Ruby code:

    window.will_close do
      # perform something
    end

Notice that we do not have to worry about the `sender` parameter
because the sender is `window`.

To enable HotCocoa style delegation, you map individual delegate
methods to a symbol name, then map parameters that are passed to that
delegate method to the block parameters. For `NSWindow` the definition
for delegating `windowWillClose`, which passes no parameters to the
block, would be:

    HotCocoa::Mappings.map window: NSWindow do
      delegating 'windowWillClose:', to: :will_close
    end

This creates a `#will_close` method that accepts the block (as
above). For the sake of efficiency, it:

1. creates an object
2. adds the delegating method (`#windowWillClose`) as a method on that
   object's singleton class
3. stores the passed-in block inside that object

The generated `#windowWillClose` method calls that block when Cocoa
calls the `#windowWillClose` method. Each time a delegate method is
created, the object is set as the delegate (using `#setDelegate`).

When a delegate needs to forward parameters to the block, the
definition becomes a little more complex:

    HotCocoa::Mappings.map window: NSWindow do
      delegating 'window:willPositionSheet:usingRect:', to: :will_position_sheet, parameters: [:willPositionSheet, :usingRect]
    end

The `parameters:` list contains the corresponding selector name from
the Objective-C selector. Even though the delegate method normally has
three parameters (`window`, `willPositionSheet`, and `usingRect`), the
block will only be passed the last two (because we already have the
first parameter). Using this method would look like:

    window.will_position_sheet do |sheet, rect|
      # ...
    end

It's also possible to map a parameter, in cases where you have to
invoke a more complex calling on the parameter:

    HotCocoa::Mappings.map window: NSWindow do
      delegating 'windowDidExpose:', to: :did_expose, parameters: ["windowDidExpose.userInfo['NSExposedRect']"]
    end

Here we want to walk the first parameter's `userInfo` dictionary, get
the `NSExposedRect` rectangle, and pass it as a parameter to the
`did_expose` block.  Using this method would look like:

    window.did_expose do | rect|
      # ...
    end

Each method for a delegate has to be mapped with an individual
delegating call.

### When To Make A Mapping

The best candidates for a new HotCocoa mappings are classes that
require a lot of configuration. Though sometimes it is convenient to
make a mapping just to take advantage of a mapping feature that
HotCocoa provides, such as block-based delegation.

If you have mappings that you would like to share, feel free to open a
pull request on [Github](http://github.com/ferrous26/hotcocoa).

## Appspecs and build tasks: building your app without XCode

### The appspec

@todo

### Rake build tasks

@todo

## Example applications

@todo

|                                      |                              |
|:-------------------------------------|:-----------------------------|
| calculator                           | A simple calculator example. |
| demo                                 | Demo of many hotcocoa wrappers. |
| layout\_view                         | Demo of using the layout view system. |
| round\_transparent_window            | Port of an Apple sample showing how to use hotcocoa with a nib files. |
| round\_transparent\_window\_no\_nibs | Same as round\_transparent\_window but without using any nibs. |
| download\_and\_progress\_indicator   | Demo of downloading data, progress indicator and scroll view containing a text view. |
| hotconsole                           | An IRB-like console using WebKit. |


## Troubleshooting

### App crashes upon start up

If the app crashes with the following error:

    LSOpenURLsWithRole() failed with error -10810 for the file ...

This is a very general error and can be caused by a number of things. Known root causes are:

1. Missing [bridge support](http://macruby.org/blog/2010/10/08/bridgesupport-preview.html) files (for Snow Leopard users)
2. Bug in the app you are launching
3. Bug in HotCocoa

Sometimes debug information will be available in the Console (/Applications/Utilities/Console.app), so you should check in there first. Failing that, you will need to rely on your general debugging skills to find the reason.