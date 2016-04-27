# Error handler that render errors
class Core::Middleware::ErrorRenderer < Core::Middleware
  attr_accessor :controller

  # Sets a controller to render
  # @param [Core::Controller] controller
  def initialize(controller)
    self.controller = controller
  end

  # Handle errors and process them
  # @return [[Core::Command], [Object]]
  def call
    return self.next
  rescue Core::Errors::UnauthorizedError
    controller.render json: { error: 'Unauthorized' }, status: 401
  rescue Core::Errors::ForbiddenError
    controller.render json: { error: 'Forbidden' }, status: 403
  rescue Core::Errors::ValidationError => e
    controller.render json: e.command.errors, status: 422
  rescue StandardError => e
    controller.render json: { error: e.message, backtrace: e.backtrace }, status: 500
  end
end
