# Common controller methods
class Core::Controller < ActionController::Base
  # Runs the action
  # @param [Core::Command] command
  # @see Core::FilterChain
  def run(command)
    Core::FilterChain.new(filters_list).run(command)
  end

  # Returns a list of filters needed to process commands
  # @return [Array]
  # @see Core::Filter
  # @see Core::Filter::ErrorRenderer
  # @see Core::Filter::Renderer
  # @see Core::Filter::AuthorizationChecker
  # @see Core::Filter::ValidationChecker
  # @see Core::Filter::Executor
  def filters_list
    [
        Core::Filter::ErrorRenderer.new(self),
        Core::Filter::Renderer.new(self),
        Core::Filter::AuthorizationChecker.new,
        Core::Filter::ValidationChecker.new,
        Core::Filter::Executor.new
    ]
  end
end
