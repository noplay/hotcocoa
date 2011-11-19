class TestMatrix < MiniTest::Unit::TestCase
  def test_defaults
    matrix = HotCocoa.matrix(frame: [0,0,10,10])
    assert_equal NSMakeRect(0,0,10,10), matrix.frame
    assert_equal NSRadioModeMatrix, matrix.mode
    assert_equal 0, matrix.numberOfRows
    assert_equal 0, matrix.numberOfColumns
    assert_equal NSActionCell, matrix.cellClass
  end

  def test_number_of_rows_and_columns
    matrix = HotCocoa.matrix(frame: [0,0,10,10], rows: 3, columns: 2)
    assert_equal 2, matrix.numberOfColumns
    assert_equal 3, matrix.numberOfRows
  end

  def test_access_to_cells
    matrix = HotCocoa.matrix(frame: [0,0,10,10], rows: 3, columns: 2)
    assert_equal (matrix.cellAtRow 0, column: 1), matrix[0, 1]
  end
end
