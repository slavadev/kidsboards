# Common controller methods
class Core::Controller < ActionController::Base
  around_action Core::Filter::ErrorRenderer

  # Runs the action
  # @param [Core::Command] command
  # @see Core::FilterChain
  def run(command)
    command.check_authorization
    command.check_validation
    result = command.execute
    render json: result, status: result ? 200 : 204
  end
end
