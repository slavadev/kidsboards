# Photo create command
class File::Command::PhotoCreateCommand < Core::Command
  attr_accessor :file

  validates :file, presence: true, content_type: %r{\Aimage/.*\Z}

  # Run command
  def execute
    user = User::User.get_user_by_token_code(token, User::Token::TYPE_LOGIN)
    photo = File::Photo.new(user, file)
    photo.save
    { id: photo.id, url: ENV['UPLOAD_HOST'] + photo.file.url }
  end
end
