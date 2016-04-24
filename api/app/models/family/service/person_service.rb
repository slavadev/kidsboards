# Contains methods to work with adults and chilren
class Family::Service::PersonService < Core::Service
  include Core::Deletable
  # Sets all variables
  # @see Family::Child
  # @see Family::Adult
  def initialize(person_model)
    @model = person_model
  end

  # Creates a person
  # @param [User::User] user
  # @param [String] name
  # @param [String] photo_url
  def create(user, name, photo_url)
    model = @model.new
    model.user = user
    model.name = name
    model.photo_url = photo_url
    model
  end

  # Converts attributes to hash
  # @param [ActiveRecord::Base] person
  # @return [Hash]
  def person_to_hash(person)
    {
        id: person.id,
        name: person.name,
        photo_url: person.photo_url
    }
  end

  # Find adult owned by user and not deleted
  # @param [int] id
  # @param [User::User] user
  # @return [Family::Adult]
  def find_actual_by_id_and_user(id, user)
    @model.where(id: id, user_id: user.id).not_deleted.take
  end
end