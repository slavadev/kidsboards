# Checks that the model exists
class Core::Validator::ExistsValidator < ActiveModel::EachValidator
  # Validation function
  # @param [Object] record
  # @param [String] attribute
  # @param [Object] _value
  def validate_each(record, attribute, _value)
    items = options[:with].call(record)
    record.errors.add(attribute, 'does not exist') unless items
  rescue
    record.errors.add(attribute, 'is wrong')
  end
end
