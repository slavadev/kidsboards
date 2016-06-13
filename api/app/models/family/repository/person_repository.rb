# Contains methods to work with adults and children entities
class Family::Repository::PersonRepository < Core::Repository
  include Core::Deletable
  # Sets all variables
  # @see Family::Child
  # @see Family::Adult
  def initialize(person_model)
    @model = person_model
  end

  # Finds adult owned by user and not deleted
  # @param [int] id
  # @param [User::User] user
  # @return [Family::Adult]
  def find_actual_by_id_and_user(id, user)
    @model.where(id: id, user_id: user.id).not_deleted.take
  end
end
