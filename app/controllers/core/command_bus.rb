# Class needed to run a command through all of needed middleware
class Core::CommandBus
  # Builds a chain from all of given middleware
  # @param [Core::Middleware[]] middleware_list
  def initialize(middleware_list)
    last_middleware = nil
    middleware = middleware_list.pop
    while middleware
      middleware.next_middleware = last_middleware
      last_middleware = middleware
      middleware = middleware_list.pop
    end
    @middleware = last_middleware
  end

  # Run a command through all of middleware
  # @param [Core::Command] command
  def run(command)
    @middleware.command = command
    @middleware.call
  end
end
