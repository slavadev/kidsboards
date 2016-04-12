# Common controller methods
class Core::Controller < ActionController::Base
  # Runs the action
  # @param [Core::Command] command
  # @see Core::CommandBus
  def run(command)
    Core::CommandBus.new(middleware_list).run(command)
  end

  # Returns a list of middleware needed to process commands
  # @return [Array]
  # @see Core::Middleware
  # @see Core::Middleware::ErrorRenderer
  # @see Core::Middleware::Renderer
  # @see Core::Middleware::AuthorizationChecker
  # @see Core::Middleware::ValidationChecker
  # @see Core::Middleware::Executor
  def middleware_list
    [
        Core::Middleware::ErrorRenderer.new(self),
        Core::Middleware::Renderer.new(self),
        Core::Middleware::AuthorizationChecker.new,
        Core::Middleware::ValidationChecker.new,
        Core::Middleware::Executor.new
    ]
  end
end
