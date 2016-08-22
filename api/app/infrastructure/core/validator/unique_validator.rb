# Checks that the model is unique
class Core::Validator::UniqueValidator < ActiveModel::EachValidator
  # Validation function
  # @param [Object] record
  # @param [String] attribute
  # @param [Object] _value
  def validate_each(record, attribute, _value)
    items = options[:with].call(record)
    record.errors.add(attribute, 'is not unique') if items
  rescue
    record.errors.add(attribute, 'is wrong')
  end
end
