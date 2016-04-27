# Goal class
# Fields:
#  [Integer]        id
#  [String]         name
#  [String]         photo_url
#  [Integer]        target
#  [Integer]        current
#  [DateTime]       deleted_at
#  [DateTime]       created_at
#  [DateTime]       updated_at
#  [User::User]     user
#  [Family::Child]  child
#  [Goal::Action][] actions
class Goal::Goal < ActiveRecord::Base
  extend Core::Deletable

  belongs_to :user, inverse_of: :goals, class_name: 'User::User'
  belongs_to :child, inverse_of: :goals, class_name: 'Family::Child'
  has_many   :actions, class_name: 'Goal::Action'

  # Adds or removes points
  # @param [int] diff
  # @return [int]
  def change_points(diff)
    real_diff = self.current
    self.current += diff.to_i
    self.current = self.target if self.current > self.target
    self.current = 0 if self.current < 0
    real_diff = self.current - real_diff
    real_diff
  end
end
