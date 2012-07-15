require 'rubygems' unless deployed?
require 'hotcocoa'

class FullScreen
  include HotCocoa

  def start
    application name: 'FullScreen' do |app|
      app.delegate = self
      @win = window frame: [100, 100, 500, 500], title: app.name, collectionBehavior: NSWindowCollectionBehaviorFullScreenPrimary do |win|
        win << label(text: 'Hello from HotCocoa', layout: {start: false})
        win.will_close { exit }

        win.will_enter_full_screen {puts "Will Enter full screen"}
        win.did_enter_full_screen {puts "Finish entering full screen mode"}
        win.will_exit_full_screen {puts "Will exit full screen mode"}
        win.did_exit_full_screen {puts "Finish exiting full screen mode"}
        
      end
    end
  end

  # file/open
  def on_open(menu)
  end

  # file/new
  def on_new(menu)
  end

  # help menu item
  def on_help(menu)
  end

  # This is commented out, so the minimize menu item is disabled
  #def on_minimize(menu)
  #end

  # window/zoom
  def on_zoom(menu)
  end

  # window/bring_all_to_front
  def on_bring_all_to_front(menu)
  end

  def on_toggle_full_screen(menu)
    @win.toggleFullScreen(nil)
  end
end

FullScreen.new.start
