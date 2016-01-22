# Update family command
class Family::Command::FamilyUpdateCommand < Core::Command
  attr_accessor :name, :photo_url

  validates :name,      length: { maximum: 50 }
  validates :photo_url, length: { maximum: 100 }
  validates :photo_url, uri: true

  # Run command
  def execute
    user = User::User.get_user_by_token_code(token, User::Token::TYPE_LOGIN)
    family = user.family
    family.name = name
    family.photo_url = photo_url
    family.save
    nil
  end
end
