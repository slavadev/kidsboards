# Error handler that render errors
class Core::Filter::ErrorRenderer

  class << self
    # Handle errors and process them
    # @param [Core::Controller] controller
    def around(controller)
      @controller = controller
      yield
    rescue Core::Errors::UnauthorizedError
      self.render 401, :error => 'Unauthorized'
    rescue Core::Errors::ForbiddenError
      self.render 403, :error => 'Forbidden'
    rescue Core::Errors::ValidationError => e
      self.render 422, e.command.errors.to_json
    rescue StandardError => e
      self.render 500, JSON.generate({ error: e.message, backtrace: e.backtrace })
    end

    # Handle errors and process them
    # @param [Integer] status
    # @param [Hash] json
    def render(status, json)
      @controller.response.status = status
      @controller.response.body = json
    end
  end
end
