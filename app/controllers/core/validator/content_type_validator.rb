# Checks that the content type is right
class Core::Validator::ContentTypeValidator < ActiveModel::EachValidator
  # Validation function
  # @param [Object] record
  # @param [String] attribute
  # @param [Object] value
  def validate_each(record, attribute, value)
    pattern = options[:with]
    return if value.nil?
    unless value.content_type.chomp.match pattern
      record.errors.add(attribute, 'wrong type')
    end
  end
end
