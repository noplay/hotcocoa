HotCocoa::Mappings.map matrix: NSMatrix do
  defaults rows: 0, columns: 0, mode: :radio, cell_class: NSActionCell

  constant :mode, {
    radio:     NSRadioModeMatrix,
    highlight: NSHighlightModeMatrix,
    list:      NSListModeMatrix,
    track:     NSTrackModeMatrix
  }

  def init_with_options matrix, options
    matrix.initWithFrame options.delete(:frame),
                   mode: options.delete(:mode),
              cellClass: options.delete(:cell_class),
           numberOfRows: options.delete(:rows),
        numberOfColumns: options.delete(:columns)
  end

  custom_methods do
    def [](row, column)
      cellAtRow row, column: column
    end

    def cell_size=(cell_size)
      setCellSize(cell_size)
    end
  end
end