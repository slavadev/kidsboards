# Class for middleware
class Core::Middleware
  attr_accessor :next_middleware, :command

  # Makes all the magic and call next middleware
  # @return [Core::Command], [Object]
  # @example
  #   def call
  #     action_before
  #     self.next()
  #     action_next
  #   end
  def call
  end

  # Calls next middleware
  # @return [Core::Command], [Object]
  def next
    @next_middleware.command = @command
    @next_middleware.call
  end
end
