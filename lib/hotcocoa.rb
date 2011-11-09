framework 'Cocoa'

STDOUT.reopen(IO.for_fd(NSFileHandle.fileHandleWithStandardError.fileDescriptor.to_i, 'w'))

##
# HotCocoa is a Cocoa mapping library for MacRuby. It simplifies the use
# of complex Cocoa classes using DSL techniques.
module HotCocoa; end

require 'hotcocoa/version'

# Load extensions to Ruby core classes
require 'hotcocoa/core_extensions/object'
require 'hotcocoa/core_extensions/kernel'
require 'hotcocoa/core_extensions/nsurl'
require 'hotcocoa/core_extensions/nsarray'
require 'hotcocoa/core_extensions/numeric'
require 'hotcocoa/core_extensions/range'
require 'hotcocoa/core_extensions/nsstring'
require 'hotcocoa/core_extensions/nsattributed_string'
require 'hotcocoa/core_extensions/nsmutable_attributed_string'
require 'hotcocoa/core_extensions/class'

# Load general HotCocoa stuff
require 'hotcocoa/mappings'
require 'hotcocoa/target_action_convenience'
require 'hotcocoa/behaviors'
require 'hotcocoa/mapping_methods'
require 'hotcocoa/mapper'
require 'hotcocoa/layout_view'
require 'hotcocoa/autolayout_view'
require 'hotcocoa/delegate_builder'
require 'hotcocoa/notification_listener'
require 'hotcocoa/attributed_string_helpers'
require 'hotcocoa/kvo_accessors'

# Load HotCocoa CoreData helper classes
require 'hotcocoa/data_sources/table_data_source'
require 'hotcocoa/data_sources/combo_box_data_source'
require 'hotcocoa/data_sources/outline_view_data_source'

# Force loading of mappings for loaded frameworks
HotCocoa::Mappings.reload
