# User class
# Fileds:
#  [String] email
#  [String] encrypted_password
#  [String] salt
#  [[User::Token]] tokens
class User::User
  include Mongoid::Document
  field :email,              type: String, default: ''
  field :encrypted_password, type: String, default: ''
  field :salt,               type: String, default: ''

  has_many :tokens, :class_name => 'User::Token'

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
    return encrypted_password == encrypt_password(password)
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
end
