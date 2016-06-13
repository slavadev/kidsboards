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
    if result.nil?
      render json: nil, status: 204
    else
      render json: result, status: 200
    end
  end
end
