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

  validates :name, presence: true, allow_blank: true, length: { maximum: 50 }
  validates :photo_url, length: { maximum: 100 }
  validates :photo_url, 'Core::Validator::Uri' => true

  has_many   :goals, class_name: 'Goal::Goal'
  belongs_to :user, inverse_of: :children, class_name: 'User::User'
end
