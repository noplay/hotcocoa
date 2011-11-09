class WebViewDemo

  def self.description
    'Web Views'
  end

  def self.create
    autolayout frame: CGRectZero, constraint: {expand: [:width, :height]}, margin: 0, spacing: 0 do |view|
      web_view = web_view(constraint: {expand: [:width, :height]}, url: 'http://www.ruby-lang.org')
      view << web_view
      view << layout_view(mode: :horizontal, frame: [0, 0, 0, 40], constraint: {expand: :width, bottom_padding: 2}, margin: 0, spacing: 0) do |hview|
        hview << button(title: 'Go', constraint: {align: :center}).on_action do
          web_view.url = @url.to_s
        end
        @url = text_field(constraint: {expand: :width, align: :center})
        hview << @url
      end
    end
  end

  DemoApplication.register self

end

