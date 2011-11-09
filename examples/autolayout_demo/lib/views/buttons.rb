class ButtonsView

  def self.description
    'Buttons'
  end

  def self.create
    action = proc do
      alert(message: 'This is an alert!', info: 'This is a little more info!')
    end

    layout_view frame: CGRectZero, layout: {expand: [:width, :height]} do |view|
      view << button(title: 'Rounded', bezel: :rounded, constraint: {expand: :width, start: false}, on_action: action)
      view << button(title: 'Regular Square', bezel: :regular_square, constraint: {expand: :width, start: false}, on_action: action)
      view << button(title: 'Thick Square', bezel: :thick_square, constraint: {expand: :width, start: false}, on_action: action)
      view << button(title: 'Thicker Square', bezel: :thicker_square, constraint: {expand: :width, start: false}, on_action: action)
      #view << button(title: '', bezel: :disclosure, constraint: {expand: :width, start: false}, on_action: action)
      view << button(title: 'Shadowless Square', bezel: :shadowless_square, consraint: {expand: :width, start: false}, on_action: action)
      #view << button(title: '', bezel: :circular, constraint: {expand: :width, start: false}, on_action: action)
      view << button(title: 'Textured Square', bezel: :textured_square, constraint: {expand: :width, start: false}, on_action: action)
      #view << button(title: 'Help Button', bezel: :help_button, constraint: {expand: :width, start: false}, on_action: action)
      view << button(title: 'Small Square', bezel: :small_square, constraint: {expand: :width, start: false}, on_action: action)
      view << button(title: 'Textured Rounded', bezel: :textured_rounded, constraint: {expand: :width, start: false}, on_action: action)
      view << button(title: 'Round Rect', bezel: :round_rect, constraint: {expand: :width, start: false}, on_action: action)
      view << button(title: 'Recessed', bezel: :recessed, constraint: {expand: :width, start: false}, on_action: action)
      #view << button(title: '', bezel: :rounded_disclosure, constraint: {expand: :width, start: false}, on_action: action)
    end
  end

  DemoApplication.register self

end
