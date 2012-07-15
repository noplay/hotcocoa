framework 'Cocoa'
# A temporary hack for the Mountain Lion CoreGraphics issue
if `sw_vers -productVersion`.to_f > 10.7
  framework '/System/Library/Frameworks/CoreGraphics.framework'
end

STDOUT.reopen(IO.for_fd(NSFileHandle.fileHandleWithStandardError.fileDescriptor.to_i, 'w'))

##
# HotCocoa is a Cocoa mapping library for MacRuby. It simplifies the use
# of complex Cocoa classes using DSL techniques.
module HotCocoa; end

require 'hotcocoa/version'

# Load general HotCocoa stuff
require 'hotcocoa/mappings'
require 'hotcocoa/target_action_convenience'
require 'hotcocoa/behaviors'
require 'hotcocoa/mapping_methods'
require 'hotcocoa/mapper'
require 'hotcocoa/layout_view'
require 'hotcocoa/notification_listener'
require 'hotcocoa/attributed_string_helpers'
require 'hotcocoa/kvo_accessors'

# Load HotCocoa CoreData helper classes
require 'hotcocoa/data_sources/table_data_source'
require 'hotcocoa/data_sources/combo_box_data_source'
require 'hotcocoa/data_sources/outline_view_data_source'

# Force loading of mappings for loaded frameworks
HotCocoa::Mappings.reload

# Needs to be instatiated in order to make things show up.
# This is useful for creating elements outside of a standard
# application.
NSApplication.sharedApplication
