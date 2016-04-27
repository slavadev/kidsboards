# Contains methods to create adults and children
class Family::Factory::PersonFactory
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
end
