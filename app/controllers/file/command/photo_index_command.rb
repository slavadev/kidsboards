# Photo index command
class File::Command::PhotoIndexCommand < Core::Command
  attr_accessor :token

  # Run command
  def execute
    user = User::User.get_user_by_token_code(self.token, User::Token::TYPE_LOGIN)
    photos = File::Photo.where(user: user, deleted_at: nil)
    if photos.nil?
      photos = []
    else
      photos = photos.map{|p| p.url}
    end
    {photo_urls: photos}
  end
end