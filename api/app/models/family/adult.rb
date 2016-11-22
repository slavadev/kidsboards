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

  validates :name, presence: true, allow_blank: true, length: { maximum: 50 }
  validates :photo_url, length: { maximum: 100 }
  validates :photo_url, 'Core::Validator::Uri' => true

  belongs_to :user, inverse_of: :adults, class_name: 'User::User'
  has_many   :actions, class_name: 'Goal::Action'

  # Creates an adult
  # @param [User::User] user
  # @param [String] name
  # @param [String] photo_url
  def initialize(user, name, photo_url)
    super()
    self.user = user
    self.name = name
    self.photo_url = photo_url
  end
end
