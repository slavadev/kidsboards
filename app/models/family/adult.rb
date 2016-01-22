# Adult class
# Fileds:
#  [Integer]        id
#  [String]         name
#  [String]         photo_url
#  [DateTime]       deleted_at
#  [DateTime]       created_at
#  [DateTime]       updated_at
#  [User::User]     user
class Family::Adult < ActiveRecord::Base
  belongs_to :user, inverse_of: :adults, class_name: 'User::User'

  # Generates adult
  # @param [User::User] user
  def initialize(user)
    super()
    self.user = user
  end
end
