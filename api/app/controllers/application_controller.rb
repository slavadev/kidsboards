class ApplicationController < ActionController::Base
  around_action Core::Filter::ErrorRenderer

  # Checks the user
  def authorize!
    code = params[:token]
    type = User::Token::TYPE_LOGIN
    @token = User::Token.includes(:user).where(code: code, token_type: type).first
    raise Core::Errors::UnauthorizedError if @token.nil?
    @user = @token.user
  end
end