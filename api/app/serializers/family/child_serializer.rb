# Describes how to show a child
class Family::ChildSerializer < ActiveModel::Serializer
  attributes :id, :name, :photo_url
end