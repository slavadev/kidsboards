# Create person(adult or child) command
class Family::Command::PersonCreateCommand < Core::Command
  attr_accessor :name, :photo_url, :model

  validates :name,      presence: true, length: { maximum: 50 }
  validates :photo_url, length: { maximum: 100 }
  validates :photo_url, uri: true

  # Run command
  def execute
    user = User::User.get_user_by_token_code(token, User::Token::TYPE_LOGIN)
    person = self.model.new(user)
    person.name = name
    person.photo_url = photo_url
    person.save
    {id: person.id}
  end
end
