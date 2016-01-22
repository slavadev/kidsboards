# Family class
# Fileds:
#  [Integer]    id
#  [String]     name
#  [String]     photo_url
#  [DateTime]   created_at
#  [DateTime]   updated_at
#  [User::User] user
#  [Family::Adult][] adults
class Family::Family < ActiveRecord::Base
  belongs_to :user, inverse_of: :family, class_name: 'User::User'
  has_many :adults, class_name: 'Family::Adult'

  # Generates family with user
  # @param [User::User] user
  def initialize(user)
    super()
    self.user = user
  end
end
