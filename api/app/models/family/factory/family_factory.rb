# Contains methods to create families
class Family::Factory::FamilyFactory
  # Sets all variables
  # @see Family::Family
  def initialize
    @model = Family::Family
  end

  # Creates a family
  # @param [User::User] user
  # @param [String] name
  # @param [String] photo_url
  def create(user, name = '', photo_url = nil)
    model = @model.new
    model.user = user
    model.name = name
    model.photo_url = photo_url
    model
  end
end
