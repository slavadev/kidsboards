# Photo index command
class File::Command::PhotoIndexCommand < Core::Command
  # Run command
  def execute
    user = User::User.get_user_by_token_code(token, User::Token::TYPE_LOGIN)
    photos = File::Photo.where(user: user, deleted_at: nil)
    if photos.nil?
      photos = []
    else
      photos = photos.map(&:url)
    end
    { photo_urls: photos }
  end
end
