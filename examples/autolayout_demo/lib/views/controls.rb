class ControlsView

  class Person < Struct.new(:first, :last)
    def to_s
      "#{first} #{last}"
    end
  end

  def self.description
    'Other Controls'
  end

  def self.create
    output_view = text_field_view
    autolayout frame: CGRectZero, constraint: {expand: [:width, :height]} do |view|
      view << layout_view(frame: [0, 0, 0, 40], mode: :horizontal, constraint: {expand: :width, start: false}) do |hview|
        hview << label(text: 'TextField', frame: [0, 0, 100, 25], constraint: {start: false, align: :center, left_padding: 10})
        hview << output_view
      end
      view << layout_view(frame: [0, 0, 0, 40], mode: :horizontal, constraint: {expand: :width, start: false}) do |hview|
        hview << label(text: 'Combo Box', frame: [0, 0, 100, 25], constraint: {start: false, align: :center, left_padding: 10})
        hview << combox_box_view(output_view)
      end
      view << layout_view(frame: [0, 0, 0, 40], mode: :horizontal, constraint: {expand: :width, start: false}) do |hview|
        hview << label(text: 'Popup', frame: [0, 0, 100, 25], constraint: {start: false, align: :center, left_padding: 10})
        hview << popup_view(output_view)
      end
      view << layout_view(frame: [0, 0, 0, 40], mode: :horizontal, constraint: {expand: :width, start: false}) do |hview|
        hview << label(text: 'Secure Text Field', frame: [0, 0, 100, 25], constraint: {start: false, align: :center, left_padding: 10})
        hview << secure_text_field_view
      end
    end
  end

  def self.combox_box_view output_view
    people = [
      Person.new("Rich", "Kilmer"),
      Person.new("Chad", "Fowler"),
      Person.new("Tom", "Copeland")
    ]
    combo_box(
              frame: [0, 0, 300, 25],
              data: people,
              constraint: {expand: :width, start: true, align: :center},
              on_action: proc {|c| output_view.text = c.to_s}
              )
  end

  def self.popup_view output_view
    popup(
          frame: [120, 80, 110, 25],
          title: 'Push Me!',
          items: ['One', 'Two', 'Three'],
          constraint: {expand: :width, start: true, align: :center},
          on_action: proc {|p| output_view.text = p.items.selected.to_s}
          )
  end

  def self.secure_text_field_view
    secure_text_field(echo: true, frame: [20, 20, 200, 25], constraint: {expand: :width, start: true, align: :center}, drawsBackground: false)
  end

  def self.text_field_view
    text_field(frame: [20, 20, 200, 25], constraint: {expand: :width, start: true, align: :center}, drawsBackground: false)
  end

  DemoApplication.register self

end
