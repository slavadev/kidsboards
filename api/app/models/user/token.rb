# Token class
# Fileds:
#  [Integer]    id
#  [String]     code
#  [DateTime]   created_at
#  [Integer]    is_expired
#  [Integer]    token_type
#  [User::User] user
class User::Token < ActiveRecord::Base
  belongs_to :user, inverse_of: :tokens, class_name: 'User::User'

  # Types
  # For Login
  TYPE_LOGIN        = 0
  # For confirmation
  TYPE_CONFIRMATION = 1
  # For recovery
  TYPE_RECOVERY     = 2

  validates :code, :created_at, :token_type, presence: true, on: :create
  validates :token_type, inclusion: { in: [TYPE_LOGIN, TYPE_CONFIRMATION, TYPE_RECOVERY] }

  # Creates a token with type
  # @param [String] type
  def initialize(type)
    super()
    self.code = SecureRandom.hex
    self.created_at = DateTime.now.utc
    self.is_expired = false
    self.token_type = type
  end

  # Sets expired flag
  # @return [User::Token]
  def expire
    self.is_expired = true
  end
end
