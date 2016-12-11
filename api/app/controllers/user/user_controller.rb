# User controller
class User::UserController < ApplicationController
  before_action :set_token_type_for_confirmation, only: [:confirm]
  before_action :set_token_type_for_recovery, only: [:recovery]
  before_action :authorize!, only: [:logout, :confirm, :recovery, :pin_set, :pin_check]
  before_action :get_email_and_password, only: [:register, :login]
  after_action :send_confirmation_email, only: :register
  after_action :send_recovery_email, only: :request_recovery

  # Method for registration
  def register
    @user = User::User.new(@email, @password)
    @token = @user.create_token(User::Token::TYPE_CONFIRMATION)
    @user.save!
    render json: @user
  end

  # Method for login
  def login
    user = User::User.find_by_email(@email)
    raise Core::Errors::UnauthorizedError, 'Wrong email or password' unless user && user.password_is_right?(@password)
    token = user.create_token(User::Token::TYPE_LOGIN)
    token.save!
    render json: token
  end

  # Method for logout
  def logout
    @token.expire
    @token.save!
  end

  # Method for confirmation
  def confirm
    @user.confirm
    @user.save!
    @token.expire
    @token.save!
  end

  # Method for request password recovery
  def request_recovery
    @user = User::User.find_by_email(params[:email])
    return if @user.nil?
    @token = @user.create_token(User::Token::TYPE_RECOVERY)
    @token.save!
  end

  # Method for password recovery
  def recovery
    password = params[:password] || ''
    @user.update!(password: password)
    @token.expire
    @token.save!
  end

  # Method for setting the pin
  def pin_set
    @user.update!(pin: params[:pin])
  end

  # Method for checking the pin
  def pin_check
    render json: { equal: @user.pin == params[:pin] }
  end

  # Method for the loader.io verification
  def loader
    render plain: 'loaderio-8fd226ca0551bbb679e5234f2b165e72'
  end

  private

  # Params for a user
  def get_email_and_password
    @email = params[:email] || ''
    @password = params[:password] || ''
  end

  # Sends a confirmation email
  def send_confirmation_email
    Mailer.confirmation_email(@user.email, @token.code).deliver_later
  rescue => e
    Rails.logger.error 'Mail sending error: ' + e.message
  end

  # Sends a recovery email
  def send_recovery_email
    Mailer.recovery_email(@user.email, @token.code).deliver_later
  rescue => e
    Rails.logger.error 'Mail sending error: ' + e.message
  end

  # Sets right token type
  def set_token_type_for_confirmation
    @token_type = User::Token::TYPE_CONFIRMATION
  end

  # Sets right token type
  def set_token_type_for_recovery
    @token_type = User::Token::TYPE_RECOVERY
    @not_show_authorization_error = true
  end
end
