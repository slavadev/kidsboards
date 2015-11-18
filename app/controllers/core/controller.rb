# Common controller methods
class Core::Controller < ApplicationController
  # Runs the action
  # @param [Core::Command] command
  def run(command)
    if command.invalid?
      raise Core::Errors::ValidationError.new(command)
    end

    result = command.execute

    if result.nil?
      render json: nil, status: 204
    else
      render json: result, status: 200
    end
  end

  # Catch validation errors
  rescue_from Core::Errors::ValidationError do |exception|
    render json: exception.command.errors, status: 422
  end

end