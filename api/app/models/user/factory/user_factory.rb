# Contains methods to create users
class User::Factory::UserFactory
  # Sets all variables
  # @see User::User
  def initialize
    @model = User::User
  end

  # Creates a user
  # @param [String] email
  # @param [String] password
  def create(email, password)
    model = @model.new
    model.email = email
    model.password = password
    model.confirmed_at = nil
    model
  end
end
