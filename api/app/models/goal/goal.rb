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
  include Core::Deletable
  extend Core::Deletable::ClassMethods

  belongs_to :user, inverse_of: :goals, class_name: 'User::User'
  belongs_to :child, inverse_of: :goals, class_name: 'Family::Child'
  has_many   :actions, class_name: 'Goal::Action'

  # Generates a goal
  # @param [User::User]    user
  # @param [Family::Child] child
  # @param [Integer]       target
  # @param [String]        name
  def initialize(user, child, target, name, photo_url)
    super()
    self.user = user
    self.child = child
    self.target = target
    self.name = name
    self.photo_url = photo_url
    self.current = 0
  end

  # Adds or removes points
  # @param [int] diff
  # @return [int]
  def change_points(diff)
    self.lock!
    real_diff = self.current
    self.current += diff.to_i
    self.current = self.target if self.current > self.target
    self.current = 0 if self.current < 0
    real_diff = self.current - real_diff
    real_diff
  end

  # Gets hash from goal
  # @return [Hash]
  def to_hash
    {
        id: id,
        name: name,
        photo_url: photo_url,
        target: target,
        current: current
    }
  end

  # Gets hash with full info from goal
  # @return [Hash]
  def full_info
    {
        id: id,
        name: name,
        photo_url: photo_url,
        target: target,
        current: current,
        created_at: created_at,
        actions: get_actions
    }
  end

  private

  # Gets goal's actions
  # @return [Hash]
  def get_actions
    actions.map do |action|
      {
          adult: {
              id: action.adult.id,
              name: action.adult.name,
              photo_url: action.adult.photo_url
          },
          diff: action.diff,
          created_at: action.created_at
      }
    end
  end
end
