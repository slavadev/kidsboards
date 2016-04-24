# Contains basic methods to work with users
class User::Service::UserService < Core::Service
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

  # Finds a user by email
  # @param [String] email
  # @return [User::User]
  def find_by_email(email)
    @model.find_by_email(email)
  end

  # Confirms email
  # @param [User::User] model
  # @return [User::User]
  def confirm(model)
    model.confirmed_at = DateTime.now.utc
    model
  end
end
