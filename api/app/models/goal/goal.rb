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
  has_many :actions, class_name: 'Goal::Action'

  validates :name, presence: true, allow_blank: true, length: { maximum: 50 }
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
  # @param [int] diff
  # @return [int]
  def change_points(diff)
    real_diff    = current
    self.current += diff.to_i
    self.current = target if self.current > target
    self.current = 0 if self.current < 0
    real_diff    = self.current - real_diff
    real_diff
  end
end
