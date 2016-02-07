# Update family command
class Family::Command::FamilyUpdateCommand < Core::Command
  attr_accessor :name, :photo_url

  validates :name,      length: { maximum: 50 }
  validates :photo_url, length: { maximum: 100 }
  validates :photo_url, 'Core::Validator::Uri' => true

  # Run command
  def execute
    user = User::User.get_user_by_token_code(token, User::Token::TYPE_LOGIN)
    family = user.family
    family.name = name unless name.nil?
    family.photo_url = photo_url unless photo_url.nil?
    family.save
    nil
  end
end
