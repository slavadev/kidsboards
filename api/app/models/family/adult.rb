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
  include Family::PersonMethods
  include Core::Deletable
  extend Core::Deletable::ClassMethods

  belongs_to :user, inverse_of: :adults, class_name: 'User::User'
  has_many   :actions, class_name: 'Goal::Action'

  # Find adult owned by user and not deleted
  # @param [int] id
  # @param [User::User] user
  # @return [Family::Adult]
  def self.find_actual_by_id_and_user(id, user)
    where(id: id, user_id: user.id).not_deleted.take
  end
end
