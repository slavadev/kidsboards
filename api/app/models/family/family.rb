# Family class
# Fields:
#  [Integer]         id
#  [String]          name
#  [String]          photo_url
#  [DateTime]        created_at
#  [DateTime]        updated_at
#  [User::User]      user
class Family::Family < ActiveRecord::Base
  belongs_to :user, inverse_of: :family, class_name: 'User::User'

  validates :name, presence: true, allow_blank: true, length: { maximum: 50 }
  validates :photo_url, length: { maximum: 100 }
  validates :photo_url, 'Core::Validator::Uri' => true

  # Gets adults
  def adults
    user.adults
  end

  # Gets children
  def children
    user.children
  end
end
