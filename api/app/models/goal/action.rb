# Action class
# Fields:
#  [Integer]        id
#  [Integer]        diff
#  [DateTime]       created_at
#  [User::User]     user
#  [Goal::Goal]     goal
#  [Family::Adult]  adult
class Goal::Action < ActiveRecord::Base
  belongs_to :user, inverse_of: :actions, class_name: 'User::User'
  belongs_to :goal, inverse_of: :actions, class_name: 'Goal::Goal'
  belongs_to :adult, inverse_of: :actions, class_name: 'Family::Adult'

  validates :diff, presence: true, numericality: { only_integer: true }, exclusion: { in: [0] }
end
