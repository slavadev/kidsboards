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
  rescue StandardError => e
    handle_error(e)
  end

  # Decide what to do with exception
  # @param [StandardError] e
  def handle_error(e)
    if [Core::Errors::UnauthorizedError, Core::Errors::ForbiddenError, Core::Errors::ValidationError].include? e.class
      fail e
    end
    fail Core::Errors::InternalError, e.message
  end

  # Catch unauthorized error
  rescue_from Core::Errors::UnauthorizedError do
    render json: { error: 'Unauthorized' }, status: 401
  end

  # Catch forbidden error
  rescue_from Core::Errors::ForbiddenError do
    render json: { error: 'Forbidden' }, status: 403
  end

  # Catch validation errors
  rescue_from Core::Errors::ValidationError do |exception|
    render json: exception.command.errors, status: 422
  end

  # Catch another errors
  rescue_from Core::Errors::InternalError do |exception|
    render json: { error: exception.message }, status: 500
  end
end
