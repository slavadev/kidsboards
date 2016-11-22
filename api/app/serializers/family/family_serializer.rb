# Describes how to show a family
class Family::FamilySerializer < ActiveModel::Serializer
  attributes :name, :photo_url
  has_many :adults do
    object.adults.not_deleted
  end
  has_many :children do
    object.children.not_deleted
  end
end