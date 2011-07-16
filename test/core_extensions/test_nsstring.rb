class TestNSStringExt < MiniTest::Unit::TestCase

  def test_convert_from_camelcase_to_underscore
    assert 'SampleCamelCasedWord'.underscore, 'sample_camel_cased_word'
  end

  def test_convert_from_underscore_to_camelcase
    assert 'sample_camel_cased_word'.camel_case, 'SampleCamelCasedWord'
  end

end
