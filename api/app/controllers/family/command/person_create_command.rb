# Create a person(an adult or a child) command
class Family::Command::PersonCreateCommand < Core::Command
  attr_accessor :name, :photo_url, :model

  validates :name,      presence: true, length: { maximum: 50 }
  validates :photo_url, length: { maximum: 100 }
  validates :photo_url, 'Core::Validator::Uri' => true

  # Runs command
  # @return [Hash]
  def execute
    user = User::User.get_user_by_token_code(token, User::Token::TYPE_LOGIN)
    person = model.new(user, name, photo_url)
    person.save
    { id: person.id }
  end
end
