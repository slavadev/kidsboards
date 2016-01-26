# User class
# Fileds:
#  [Integer]           id
#  [String]            email
#  [String]            encrypted_password
#  [String]            salt
#  [DateTime]          confirmed_at
#  [String]            pin                  4 digital Pin code for adults
#  [[User::Token]][]   tokens
#  [[File::Photo]][]   photos
#  [[Family::Adult]][] adults
#  [[Family::Child]][] children
#  [[Family::Family]]  family
class User::User < ActiveRecord::Base
  has_many   :tokens,   class_name: 'User::Token'
  has_many   :photos,   class_name: 'File::Photo'
  has_many   :adults,   class_name: 'Family::Adult'
  has_many   :children, class_name: 'Family::Child'
  has_one    :family,   class_name: 'Family::Family'

  # Set password
  # @param [String] password
  def password=(password)
    generate_salt
    self.encrypted_password = encrypt_password(password)
  end

  # Check password
  # @param [String] password
  # @return [Boolean]
  def password_is_right?(password)
    encrypted_password == encrypt_password(password)
  end

  # Encrypt password
  # @param [String] password
  # @return [String]
  def encrypt_password(password)
    Digest::SHA2.hexdigest(salt + password)
  end

  # Generate salt
  def generate_salt
    self.salt = SecureRandom.base64(8)
  end

  # Confirm
  def confirm
    self.confirmed_at = DateTime.now.new_offset(0)
    save
  end

  # Get user by token
  # @param [String] code
  # @param [Integer] type
  # @return [User::User]
  def self.get_user_by_token_code(code, type)
    token = User::Token.where(code: code, token_type: type).first
    fail Core::Errors::UnauthorizedError if token.nil?
    token.user
  end
end
