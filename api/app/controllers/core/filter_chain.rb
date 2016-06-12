# Class needed to run a command through all of needed filters
class Core::FilterChain
  # Builds a chain from all of given filters
  # @param [Core::Filter[]] filters_list
  def initialize(filters_list)
    last_filter = nil
    filter = filters_list.pop
    while filter
      filter.next_filter = last_filter
      last_filter = filter
      filter = filters_list.pop
    end
    @filter= last_filter
  end

  # Runs a command through all of filters
  # @param [Core::Command] command
  def run(command)
    @filter.command = command
    @filter.call
  end
end
