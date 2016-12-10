# User controller
class User::UserController < ApplicationController
  before_action :set_token_type_for_confirmation, only: [:confirm]
  before_action :authorize!, only: [:logout, :confirm]
  before_action :get_email_and_password, only: [:register, :login]
  after_action :send_confirmation_email, only: :register

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
  # @see User::RequestRecoveryCommand
  def request_recovery
    command = User::RequestRecoveryCommand.new(params)
    run(command)
  end

  # Method for password recovery
  # @see User::RequestRecoveryCommand
  def recovery
    command = User::RecoveryCommand.new(params)
    run(command)
  end

  # Method for setting the pin
  # @see User::PinSetCommand
  def pin_set
    command = User::PinSetCommand.new(params)
    run(command)
  end

  # Method for checking the pin
  # @see User::PinCheckCommand
  def pin_check
    command = User::PinCheckCommand.new(params)
    run(command)
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

  # Checks the user for confirmation
  def set_token_type_for_confirmation
    @token_type = User::Token::TYPE_CONFIRMATION
  end
end
