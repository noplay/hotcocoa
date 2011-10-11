require 'test/application/helper'

class TestApplicationDocumentTypeSpecification < TestApplicationModule
  def test_definition_of_a_valid_specification
    type = DocumentTypeSpecification.new do |doc_type|
      doc_type.extensions = ["ext"]
      doc_type.icon       = "MyIcon.icns"
      doc_type.name       = "MyProjectDocument"
      doc_type.role       = :editor
      doc_type.class      = "MyDocument"
    end
    assert_equal ["ext"],             type.info_plist_representation[:CFBundleTypeExtensions]
    assert_equal "MyIcon.icns",       type.info_plist_representation[:CFBundleTypeIconFile]
    assert_equal "MyProjectDocument", type.info_plist_representation[:CFBundleTypeName]
    assert_equal "Editor",            type.info_plist_representation[:CFBundleTypeRole]
    assert_equal "MyDocument",        type.info_plist_representation[:NSDocumentClass]
  end
end
