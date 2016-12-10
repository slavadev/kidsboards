class ApplicationController < ActionController::Base
  around_action Core::Filter::ErrorRenderer
  # Scope for serializers
  serialization_scope :context
  attr_reader :context

  protected

  ## Strong params

  # Returns params for a family
  def family_params
    params.permit(:name, :photo_url)
  end

  # Returns params for children and adults
  def person_params
    params.permit(:name, :photo_url)
  end

  # Returns params for a goal
  def goal_params
    params.permit(:name, :photo_url, :target)
  end

  ## Common helpers

  # Checks the user
  def authorize!
    code = params[:token]
    @token_type ||= User::Token::TYPE_LOGIN
    @token = User::Token.includes(:user).where(code: code, token_type: @token_type).first
    raise Core::Errors::UnauthorizedError if @token.nil?
    @user = @token.user
  end
end