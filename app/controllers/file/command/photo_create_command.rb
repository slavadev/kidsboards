# Photo create command
class File::Command::PhotoCreateCommand < Core::Command
  attr_accessor :token, :file

  validates :file, presence: true
  validate :correct_content_type

  # Checks type of file
  def correct_content_type
    return if self.file.nil?
    unless self.file.content_type.chomp.match(/\Aimage\/.*\Z/)
      errors.add(:file, 'wrong type')
    end
  end

  # Run command
  def execute
    user = User::User.get_user_by_token_code(self.token, User::Token::TYPE_LOGIN)
    photo = File::Photo.new(user, self.file)
    photo.save
    {url: photo.url}
  end
end