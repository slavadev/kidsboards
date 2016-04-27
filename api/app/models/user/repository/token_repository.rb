# Contains methods to work with token entities
class User::Repository::TokenRepository < Core::Repository
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
