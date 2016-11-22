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
  has_many :tokens, class_name: 'User::Token'
  has_many :photos, class_name: 'Uploaded::Photo'
  has_many :adults, class_name: 'Family::Adult'
  has_many :children, class_name: 'Family::Child'
  has_many :goals, class_name: 'Goal::Goal'
  has_many :actions, class_name: 'Goal::Action'
  has_one :family, class_name: 'Family::Family'
  attr_accessor :password

  validates :email, :salt, :encrypted_password, :pin, presence: true
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :email, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }, on: :create
  validates :password, allow_nil: true, length: { minimum: 6 }, on: :update
  validates :pin, length: { is: 4 }
  validates :pin, format: { with: /\d{4}/, message: 'has wrong format' }

  # Creates a user
  # @param [String] email
  # @param [String] password
  def initialize(email, password)
    super()
    self.email = email
    self.password = password
    self.confirmed_at = nil
    self.family = Family::Family.new
  end

  # Sets the password
  # @param [String] password
  def password=(password)
    @password = password
    generate_salt
    self.encrypted_password = encrypt_password(password)
  end

  # Checks the password
  # @param [String] password
  # @return [Boolean]
  def password_is_right?(password)
    encrypted_password == encrypt_password(password)
  end

  # Confirms email
  # @return [User::User]
  def confirm
    self.confirmed_at = DateTime.now.utc
  end

  # Creates token
  # @param [Integer] type
  # @return [User::Token]
  def create_token(type)
    token = User::Token.new(type)
    tokens.push(token)
    token
  end

  private

  # Encrypts the password
  # @param [String] password
  # @return [String]
  def encrypt_password(password)
    password = '' if password.nil?
    Digest::SHA2.hexdigest(salt + password)
  end

  # Generates a salt
  def generate_salt
    self.salt = SecureRandom.base64(8)
  end
end
