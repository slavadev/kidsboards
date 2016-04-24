# User class
# Fileds:
#  [Integer]           id
#  [String]            email
#  [String]            encrypted_password
#  [String]            salt
#  [DateTime]          confirmed_at
#  [String]            pin                  4 digital Pin code for adults
#  [User::Token][]     tokens
#  [Uploaded::Photo][] photos
#  [Family::Adult][]   adults
#  [Family::Child][]   children
#  [Goal::Goal][]      goals
#  [Goal::Action][]    actions
#  [Family::Family]    family
class User::User < ActiveRecord::Base
  has_many   :tokens,   class_name: 'User::Token'
  has_many   :photos,   class_name: 'Uploaded::Photo'
  has_many   :adults,   class_name: 'Family::Adult'
  has_many   :children, class_name: 'Family::Child'
  has_many   :goals,    class_name: 'Goal::Goal'
  has_many   :actions,  class_name: 'Goal::Action'
  has_one    :family,   class_name: 'Family::Family'

  # Sets the password
  # @param [String] password
  def password=(password)
    generate_salt
    self.encrypted_password = encrypt_password(password)
  end

  # Checks the password
  # @param [String] password
  # @return [Boolean]
  def password_is_right?(password)
    encrypted_password == encrypt_password(password)
  end

  private

  # Encrypts the password
  # @param [String] password
  # @return [String]
  def encrypt_password(password)
    Digest::SHA2.hexdigest(salt + password)
  end


  # Generates a salt
  def generate_salt
    self.salt = SecureRandom.base64(8)
  end
end
