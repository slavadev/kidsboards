# Error handler that render errors
class Core::Filter::ErrorRenderer

  class << self
    # Handle errors and process them
    # @param [Core::Controller] controller
    def around(controller)
      @controller = controller
      yield
    rescue Core::Errors::BadRequest => e
      self.render 400, JSON.generate(:error => e.message)
    rescue Core::Errors::UnauthorizedError
      self.render 401, JSON.generate(:error => 'Unauthorized')
    rescue Core::Errors::ForbiddenError
      self.render 403, JSON.generate(:error => 'Forbidden')
    rescue Core::Errors::NotFoundError
      self.render 404, JSON.generate(:error => 'Not Found')
    rescue ActiveRecord::RecordNotFound
      self.render 404, JSON.generate(:error => 'Not Found')
    rescue ActiveRecord::RecordInvalid => e
      self.render 422, e.record.errors.to_json
    rescue StandardError => e
      self.render 500, JSON.generate({ error: e.message, class: e.class, backtrace: e.backtrace })
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
