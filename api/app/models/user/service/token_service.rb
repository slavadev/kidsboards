# Contains basic methods to work with tokens
class User::Service::TokenService < Core::Service
  # Sets all variables
  # @see User::Token
  def initialize
    @model = User::Token
  end

  # Creates a token with user and type
  # @param [User::User] user
  # @param [String] type
  def create(user, type)
    model = @model.new
    model.user = user
    model.code = SecureRandom.hex
    model.created_at = DateTime.now.utc
    model.is_expired = false
    model.token_type = type
    model
  end

  # Sets expired flag
  # @param [User::Token] model
  # @return [User::Token]
  def expire(model)
    model.is_expired = true
    model
  end
end
