# Renderer
class Core::Middleware::Renderer < Core::Middleware
  attr_accessor :controller

  # Sets a controller to render
  # @param [Core::Controller] controller
  def initialize(controller)
    self.controller = controller
  end

  # Renders response
  # @return [Core::Command], [Object]
  def call
    command, result = self.next
    if result.nil?
      controller.render json: nil, status: 204
    else
      controller.render json: result, status: 200
    end
    return command, result
  end
end
