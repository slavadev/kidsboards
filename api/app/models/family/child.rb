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
  include Family::PersonMethods
  include Core::Deletable
  extend Core::Deletable::ClassMethods

  has_many   :goals, class_name: 'Goal::Goal'
  belongs_to :user, inverse_of: :children, class_name: 'User::User'

  # Gets child goals
  # @param [Boolean] completed
  # @return [Goal::Goal][] goals
  def get_goals(completed)
    goals = self.goals.where(deleted_at: nil)
    return goals if completed.nil?
    return goals.where('current >= target') if completed
    goals.where('current < target')
  end
end
