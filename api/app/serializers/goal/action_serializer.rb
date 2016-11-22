class Goal::ActionSerializer < ActiveModel::Serializer
  attributes :diff, :created_at, :adult
  def adult
    ActiveModelSerializers::SerializableResource.new(object.adult)
  end
end