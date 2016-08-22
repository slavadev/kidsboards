# Checks that the attribute is a valid uri
class Core::Validator::UriValidator < ActiveModel::EachValidator
  # Validation function
  def validate_each(record, attribute, value)
    return if value.nil?
    uri = URI.parse(value)
    raise unless uri.scheme && uri.host && uri
    unless %w(http https).include?(uri.scheme)
      record.errors.add(attribute, 'has wrong protocol (use http or https)')
    end
  rescue
    record.errors.add(attribute, 'is a bad uri')
  end
end
