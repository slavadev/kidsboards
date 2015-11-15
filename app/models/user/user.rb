# User class
# Fileds:
#  [String] email
#  [String] encrypted_password
#  [String] salt
class User::User
  include Mongoid::Document
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""
  field :salt,               type: String, default: ""

  # Set password
  # @param [String] password
  def password=(password)
    self.encrypted_password = encrypt_password(password)
  end

  # Encrypt password
  # @param [String] password
  # @return [String]
  def encrypt_password(password)
    self.salt = SecureRandom.base64(8)
    Digest::SHA2.hexdigest(self.salt + password)
  end
end
