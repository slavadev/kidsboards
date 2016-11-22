# Describes how to show an adult
class Family::AdultSerializer < ActiveModel::Serializer
  attributes :id, :name, :photo_url
end