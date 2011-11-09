class TableView

  def self.description
    'Tables'
  end

  def self.create
    autolayout frame: CGRectZero, constraint: {expand: [:width, :height]}, margin: 0, spacing: 0 do |view|
      view << scroll_view(constraint: {expand: [:width, :height]}) do |scroll|
        scroll << table_view(
                             columns: [
                                       column(id: :first_name, title: 'First'),
                                       column(id: :last_name,  title: 'Last')
                                      ],
                             data: [
                                    { first_name: 'Richard', last_name: 'Kilmer'},
                                    { first_name: 'Chad',    last_name: 'Fowler'}
                                   ]
                             )
      end
    end
  end

  DemoApplication.register self

end
