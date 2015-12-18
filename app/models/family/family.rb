# Family class
# Fileds:
#  [String]     name
#  [String]     photo_url
#  [User::User] user
class Family::Family
  include Mongoid::Document
  field :name,      type: String, default: ''
  field :photo_url, type: String, default: nil

  embedded_in :user, inverse_of: :family, class_name: 'User::User'

  # Generates family with user
  # @param [User::User] user
  def initialize(user)
    super()
    self.user = user
  end

  # Attributes visible for public
  def view
    {
        id: self.id,
        name: self.name,
        photo_url: self.photo_url
    }
  end
end
