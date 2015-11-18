# Token class
# Fileds:
#  [String]     code
#  [DateTime]   created_at
#  [Integer]    is_expired
#  [User::User] user
class User::Token
  include Mongoid::Document
  field :code, type: String, default: ''
  field :created_at, type: DateTime
  field :is_expired, type: Boolean
  field :type, type: Integer

  belongs_to :user, :inverse_of => :tokens, :class_name => 'User::User'

  # Types
  # For Login
  TYPE_LOGIN = 0
  # For confirmation
  TYPE_CONFIRMATION = 1
  # For recovery
  TYPE_RECOVERY = 2

  # New token with user and type
  # @param [User::User] user
  # @param [Integer] type
  def initialize(user, type)
    super()
    self.user = user
    self.code = SecureRandom.base64
    self.created_at = DateTime.now.new_offset(0)
    self.is_expired = false
    self.type = type
  end

  # Set expired flag
  def expire
    self.is_expired = true
  end
end
