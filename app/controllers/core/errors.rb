# List of errors
class Core::Errors
  ## Validation error
  class ValidationError < StandardError
    attr_accessor :command
    def initialize(command)
      self.command = command
    end
  end

  ## Not found error
  class NotFoundError < StandardError
  end

  ## Forbidden error
  class ForbiddenError < StandardError
  end

  ## Unauthorized error
  class UnauthorizedError < StandardError
  end
end