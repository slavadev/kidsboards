# Error handler that render errors
class Core::Filter::ErrorRenderer

  class << self
    # Handle errors and process them
    # @param [Core::Controller] controller
    def around(controller)
      @controller = controller
      yield
    rescue Core::Errors::BadRequest => e
      self.render 400, JSON.generate(:error => e.message || 'Bad Request')
    rescue Core::Errors::UnauthorizedError => e
      self.render 401, JSON.generate(:error => e.message || 'Unauthorized')
    rescue Core::Errors::ForbiddenError => e
      self.render 403, JSON.generate(:error => e.message || 'Forbidden')
    rescue Core::Errors::NotFoundError => e
      self.render 404, JSON.generate(:error => e.message || 'Not Found')
    rescue ActiveRecord::RecordNotFound => e
      self.render 404, JSON.generate(:error => e.message || 'Not Found')
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
