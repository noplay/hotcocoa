framework 'Cocoa'
framework 'MacRuby'

def deployed?
  !NSBundle.allFrameworks.find { |x|
    x.bundleIdentifier == 'org.macruby' &&
    x.bundlePath.match(/^\/Library\/Frameworks/)
  }
end
require 'rubygems' unless deployed?
require 'hotcocoa'

class Test
  include HotCocoa

  def start
    application name: 'Test' do |app|

      app.delegate = self

      window frame: [100, 100, 500, 500], title: 'Test' do |win|

        win << (text = label(text: 'Hello from HotCocoa'))
        win << (butt = button())

        butt.constrain format: '[self]-[label]', views: { 'label' => text }

        win.will_close { exit }

      end
    end
  end

end

Test.new.start
