# Photo create command
class Uploaded::Command::PhotoCreateCommand < Core::Command
  attr_accessor :file

  validates :file, presence: true, 'Core::Validator::ContentType' => %r{\Aimage/.*\Z}

  # Runs command
  # @return [Hash]
  def execute
    user = User::User.get_user_by_token_code(token, User::Token::TYPE_LOGIN)
    photo = Uploaded::Photo.new(user, file)
    photo.save
    { id: photo.id, url: ENV['UPLOAD_HOST'] + photo.file.url }
  end
end
