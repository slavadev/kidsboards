# Checks that model unique
class UniqueValidator < ActiveModel::EachValidator

  # Validation function
  # @param [Object] record
  # @param [String] attribute
  # @param [Object] value
  def validate_each(record, attribute, value)
    model = options[:model]
    conditions = options[:conditions].call(record)
    if model.where(conditions).first
      record.errors.add(attribute, 'is not unique')
    end
  rescue
    record.errors.add(attribute, 'is wrong')
  end
end
