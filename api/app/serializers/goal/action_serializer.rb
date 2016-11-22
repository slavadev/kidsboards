# Describes how to show an action
class Goal::ActionSerializer < ActiveModel::Serializer
  attributes :diff, :created_at, :adult
  # Fix for an adult
  def adult
    ActiveModelSerializers::SerializableResource.new(object.adult)
  end
end