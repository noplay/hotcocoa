# HotCocoa

HotCocoa is a thin, idiomatic Ruby layer that sits above Cocoa and
other frameworks. The goal of the project is to simplify the process of creating
and configuring Cocoa objects used when building native Mac apps.

## Using

### Pre-requisites

1. You will need the Mac OS X developer tools in order
to build apps. Xcode is not required, but the compiler toolchain is
needed.

2. MacRuby 0.11 nightly build or higher from [macruby.org](http://www.macruby.org/downloads.html).

3. If you are on Snow Leopard, you will also need the
[Bridge Support Preview v3](http://www.macruby.org/files/BridgeSupport%20Preview%203.zip)
in order to run HotCocoa. Read about it on the
[MacRuby Blog](http://www.macruby.org/blog/2010/10/08/bridgesupport-preview.html).

### Installation

From `rubygems.org`:

    $ sudo macgem install hotcocoa

Or to get the bleeding edge, you can clone the repository on Github and install from there:

    $ git clone git://github.com/HotCocoa/hotcocoa
    $ cd hotcocoa
    $ sudo macrake install

### Documentation

Check out the [manual](http://rubydoc.info/github/HotCocoa/hotcocoa/master/file/docs/Manual.markdown) and
the developer documentation on [rdoc.info](http://rdoc.info/github/HotCocoa/hotcocoa/master/frames).

The mappings that are shipped with `hotcocoa` are currently not documented, due to the
way that mappings are implemented; a YARD plug-in or new YARD features will be needed (stay tuned).

### Examples

Have a look in the [examples folder](https://github.com/HotCocoa/hotcocoa/tree/master/examples) to see some sample apps which use HotCocoa.

## Contributing

HotCocoa has ambitious goals that are difficult to accomplish with the input of
only a few people. Feedback is the easiest way to contribute and goes a long way
to making sure HotCocoa is on the right path to accomplishing those goals.

There are still some APIs that need documentation, regression tests that need to
be written, and tutorials to be updated; but new features and improved performance
will also be coming in the not too distant future. If you find issues with
HotCocoa, don't hesitate to open tickets on Github (or try to fix it yourself and
send in the patch :)).

### Submitting patches

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Make sure to add tests for it. This is important so that your feature doesn't unintentionally break in a future version
* Commit and push until you are happy with your contribution
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so it is possible to cherry-pick around it.
* No contribution is too small!

## License

(The MIT License)

Copyright (c) 2009-2010 Richard Kilmer
Copyright (c) 2011 Mark Rada, Jake Benilov

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
