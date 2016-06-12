# Class for filter
class Core::Filter
  attr_accessor :next_filter, :command

  # Makes all the magic and call next filter
  # @return [[Core::Command], [Object]]
  # @example
  #   def call
  #     action_before
  #     self.next
  #     action_next
  #   end
  def call
  end

  protected

  # Calls next filter
  # @return [[Core::Command], [Object]]
  def next
    @next_filter.command = @command
    @next_filter.call
  end
end
