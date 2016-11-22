# Describes how to show a photo
class Uploaded::PhotoSerializer < ActiveModel::Serializer
  attributes :id, :url
  # Url attribute
  def url
    ENV['UPLOAD_HOST'] + object.file.url(:small)
  end
end