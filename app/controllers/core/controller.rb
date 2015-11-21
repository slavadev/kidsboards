# Common controller methods
class Core::Controller < ApplicationController
  # Runs the action
  # @param [Core::Command] command
  def run(command)
    authorized? (command)
    valid? (command)

    result = command.execute

    if result.nil?
      render json: nil, status: 204
    else
      render json: result, status: 200
    end
  end

  # Check for validation
  # @param [Core::Command] command
  def valid? (command)
    if command.invalid?
      raise Core::Errors::ValidationError.new(command)
    end
  end

  # Check for authorization
  # @param [Core::Command] command
  def authorized? (command)
    rules = Rails.configuration.authentication_rules
    unless rules.select{ |rule| rule['action'] == command.class.name}.blank?
      token = params['token']
      raise Core::Errors::UnauthorizedError.new if token.nil?
      type = case rules.select{ |rule| rule['action'] == command.class.name}[0]['token']
               when :login then User::Token::TYPE_LOGIN
               when :confirmation then User::Token::TYPE_CONFIRMATION
               when :recovery then User::Token::TYPE_RECOVERY
               else -1
             end
      token = User::Token.where(code: token, type: type).first
      raise Core::Errors::UnauthorizedError.new if token.nil?
    end
  end

  # Catch unauthorized error
  rescue_from Core::Errors::UnauthorizedError do
    render json: {error: 'Unauthorized'}, status: 401
  end

  # Catch forbidden error
  rescue_from Core::Errors::ForbiddenError do
    render json: {error: 'Forbidden'}, status: 403
  end

  # Catch validation errors
  rescue_from Core::Errors::ValidationError do |exception|
    render json: exception.command.errors, status: 422
  end

  # Catch another errors
  rescue_from Core::Errors::InternalError do
    render json: {error: 'Internal server error'}, status: 500
  end

end