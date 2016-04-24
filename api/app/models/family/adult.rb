# Adult class
# Fields:
#  [Integer]         id
#  [String]          name
#  [String]          photo_url
#  [DateTime]        deleted_at
#  [DateTime]        created_at
#  [DateTime]        updated_at
#  [User::User]      user
#  [Goal::Action][]  actions
class Family::Adult < ActiveRecord::Base
  extend Core::Deletable

  belongs_to :user, inverse_of: :adults, class_name: 'User::User'
  has_many   :actions, class_name: 'Goal::Action'
end
