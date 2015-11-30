# User class
# Fileds:
#  [String]        email
#  [String]        encrypted_password
#  [String]        salt
#  [DateTime]      confirmed_at
#  [String]        pin                  4 digital Pin code for adults
#  [[User::Token]] tokens
#  [[File::Photo]] photos
class User::User
  include Mongoid::Document
  field :email,              type: String, default: ''
  field :encrypted_password, type: String, default: ''
  field :salt,               type: String, default: ''
  field :confirmed_at,       type: DateTime
  field :pin,                type: String, default: '0000'

  has_many :tokens, :class_name => 'User::Token'
  has_many :photos, :class_name => 'File::Photo'

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
    Digest::SHA2.hexdigest(self.salt + password)
  end

  # Generate salt
  def generate_salt
    self.salt = SecureRandom.base64(8)
  end

  # Confirm
  def confirm
    self.confirmed_at = DateTime.now.new_offset(0)
    self.save
  end

  # Get user by token
  # @param [String] code
  # @param [Integer] type
  # @return [User::User]
  def self.get_user_by_token_code(code, type)
    token = User::Token.where(code: code, type: type).first
    raise Core::Errors::UnauthorizedError.new if token.nil?
    token.user
  end
end
