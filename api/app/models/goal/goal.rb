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
  include Core::Trait::Deletable

  belongs_to :user, inverse_of: :goals, class_name: 'User::User'
  belongs_to :child, inverse_of: :goals, class_name: 'Family::Child'
  has_many :actions, class_name: 'Goal::Action'

  scope :completed, -> { where('current >= target') }
  scope :not_completed, -> { where('current < target') }

  validates :name, presence: true, allow_blank: false, length: { maximum: 50 }
  validates :photo_url, length: { maximum: 100 }
  validates :photo_url, 'Core::Validator::Uri' => true
  validates :target, presence: true,
            numericality:                {
                only_integer: true,
                greater_than: 0,
                less_than:    1000
            }
  validates :current, presence: true,
            numericality:                {
                only_integer: true,
                less_than:    1000
            }

  # Adds or removes points
  # @param [Family::Adult] adult
  # @param [int] diff
  # @return [int]
  def change_points(adult, diff)
    real_diff    = current
    self.current += diff.to_i
    self.current = target if self.current > target
    self.current = 0 if self.current < 0
    real_diff    = self.current - real_diff
    create_action(adult, real_diff)
  end

  private

  # Creates an action for a diff
  # @param [Family::Adult] adult
  # @param [int] diff
  # @return [int]
  def create_action(adult, diff)
    action = Goal::Action.new(self.user, self, adult, diff)
    self.actions.push(action)
  end
end
