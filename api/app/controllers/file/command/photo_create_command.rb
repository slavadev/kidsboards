# Photo create command
class File::Command::PhotoCreateCommand < Core::Command
  attr_accessor :token, :file

  validates :file, presence: true
  validate :correct_content_type

  # Checks type of file
  def correct_content_type
    return if file.nil?
    unless file.content_type.chomp.match %r{\Aimage/.*\Z}
      errors.add(:file, 'wrong type')
    end
  end

  # Run command
  def execute
    user = User::User.get_user_by_token_code(token, User::Token::TYPE_LOGIN)
    photo = File::Photo.new(user, file)
    photo.save
    { url: photo.url }
  end
end
