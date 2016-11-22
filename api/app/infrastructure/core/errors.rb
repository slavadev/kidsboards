# List of errors
class Core::Errors
  # Validation error
  class ValidationError < StandardError
    attr_accessor :command
    def initialize(command)
      self.command = command
    end
  end

  # Bad request error
  class BadRequest < StandardError
  end

  # Not found error
  class NotFoundError < StandardError
  end

  # Forbidden error
  class ForbiddenError < StandardError
  end

  # Unauthorized error
  class UnauthorizedError < StandardError
  end

  # Internal error
  class InternalError < StandardError
  end

  # No model to validate error
  class NoModelToValidateError < StandardError
  end
end
