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
  include Core::Trait::Deletable

  validates :name, presence: true, allow_blank: false, length: { maximum: 50 }
  validates :photo_url, length: { maximum: 100 }
  validates :photo_url, 'Core::Validator::Uri' => true

  belongs_to :user, inverse_of: :adults, class_name: 'User::User'
  has_many   :actions, class_name: 'Goal::Action'
end
