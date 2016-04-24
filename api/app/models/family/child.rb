# Child class
# Fields:
#  [Integer]        id
#  [String]         name
#  [String]         photo_url
#  [DateTime]       deleted_at
#  [DateTime]       created_at
#  [DateTime]       updated_at
#  [User::User]     user
class Family::Child < ActiveRecord::Base
  extend Core::Deletable

  has_many   :goals, class_name: 'Goal::Goal'
  belongs_to :user, inverse_of: :children, class_name: 'User::User'
end
