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
  TYPE_LOGIN = 0
  # For confirmation
  TYPE_CONFIRMATION = 1
  # For recovery
  TYPE_RECOVERY = 2
end
