# Contains methods to work with user entities
class User::UserRepository < Core::Repository
  # Sets all variables
  # @see User::User
  def initialize
    @model = User::User
  end

  # Finds a user by email
  # @param [String] email
  # @return [User::User]
  def find_by_email(email)
    @model.find_by_email(email)
  end
end
