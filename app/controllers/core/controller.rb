# Common controller methods
class Core::Controller < ApplicationController
  include Core::ValidationChecker
  include Core::AuthorizationChecker
  include Core::Executor

  # Runs the action
  # @param [Core::Command] command
  def run(command)
    authorized? command
    valid? command
    result = execute command
    if result.nil?
      render json: nil, status: 204
    else
      render json: result, status: 200
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