# Common controller methods
class Core::Controller < ApplicationController
  # Runs the action
  # @param [Core::Command] command
  def run(command)
    command.check_authorization
    command.check_validation
    result = command.execute
    render json: result, status: result ? 200 : 204
  end
end
