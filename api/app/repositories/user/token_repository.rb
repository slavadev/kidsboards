# Contains methods to work with token entities
class User::TokenRepository < Core::Repository
  # Sets all variables
  # @see User::Token
  def initialize
    @model = User::Token
  end

  # Finds token by code and type
  # @param [Integer] code
  # @param [Integer] type
  # @return [User::Token]
  # @raise Core::Errors::UnauthorizedError
  def find_token_by_code_and_type(code, type)
    @model.where(code: code, token_type: type).first
  end
end
