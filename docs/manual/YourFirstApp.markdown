# Creating your first app

## Prerequisites

1. You will need the Mac OS X developer tools in order
to build apps. Xcode is not required, but the compiler toolchain is
needed.

2. Mac OS X 10.6+. If you are on Snow Leopard, you will also need the
[Bridge Support Preview v3](http://www.macruby.org/files/BridgeSupport%20Preview%203.zip)
in order to run HotCocoa. Read about it on the
[MacRuby Blog](http://www.macruby.org/blog/2010/10/08/bridgesupport-preview.html). Lion users do not need to install this.

## Getting up and running

Install hotcocoa from `rubygems.org`:

    $ sudo macgem install hotcocoa

Generate the app scaffolding:

    $ hotcocoa my_first_app

Start the app:

    $ cd my_first_app
    $ macrake deploy run

## The anatomy of a HotCocoa application

@todo describe all the files in the application