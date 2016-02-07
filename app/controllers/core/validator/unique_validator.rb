# Checks that the model is unique
class Core::Validator::UniqueValidator < ActiveModel::EachValidator
  # Validation function
  # @param [Object] record
  # @param [String] attribute
  # @param [Object] _value
  def validate_each(record, attribute, _value)
    model = options[:model] ? options[:model] : record.model_to_validate
    conditions = options[:with].call(record)
    if model.where(conditions).first
      record.errors.add(attribute, 'is not unique')
    end
  rescue
    record.errors.add(attribute, 'is wrong')
  end
end
