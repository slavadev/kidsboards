# Photo delete command
class File::Command::PhotoDeleteCommand < Core::Command
  attr_accessor :token, :url

  validates :url, presence: true
  validate :url_exists

  # Checks that photo exists
  def url_exists
    return if url.nil?
    user = User::User.get_user_by_token_code(token, User::Token::TYPE_LOGIN)
    if File::Photo.where(url: url, deleted_at: nil, user: user).first.nil?
      errors.add(:url, 'not exists')
    end
  end

  # Run command
  def execute
    user = User::User.get_user_by_token_code(token, User::Token::TYPE_LOGIN)
    photo = File::Photo.where(url: url, deleted_at: nil, user: user).first
    photo.deleted_at = DateTime.now.new_offset(0)
    photo.save
    nil
  end
end
