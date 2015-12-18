# Checks that attribute is valid uri
class UriValidator < ActiveModel::EachValidator

  # Validation function
  def validate_each(record, attribute, value)
    uri = URI.parse(value)
    fail unless uri.scheme && uri.host && uri
    unless ['http', 'https'].include?(uri.scheme)
      record.errors.add(attribute, 'has wrong protocol (use http or https)')
    end
  rescue
    record.errors.add(attribute, 'is a bad uri')
  end

end