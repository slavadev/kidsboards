# Photo index command
class Uploaded::Command::PhotoIndexCommand < Core::Command
  # Runs command
  # @return [Hash]
  def execute
    user = User::User.get_user_by_token_code(token, User::Token::TYPE_LOGIN)
    photos = Uploaded::Photo.where(user: user, deleted_at: nil)
    photos = photos.map { |x| { id: x.id, url: ENV['UPLOAD_HOST'] + x.file.url } }
    { photos: photos }
  end
end
