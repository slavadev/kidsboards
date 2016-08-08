# Slightly modified singleton
module Core::Multitone
  class << self
    # All magic here
    # @param [Class] klass
    def __init__(klass)
      klass.instance_eval {
        @instances = Hash.new
      }

      # Makes the same thing to subclasses
      # @param [Class] sub
      def klass.inherited(sub)
        super
        Core::Multitone.__init__(sub)
      end

      # Creates a new instance or finds one that exists
      # @param [Class] model
      # @return [Object]
      def klass.get(model = nil)
        name = model ? model.to_s : 'default'
        return @instances[name] if @instances[name]
        @instances[name] = model.nil? ? self.new : self.new(model)
        @instances[name]
      end
    end

    private

    # Runs init method when included
    # @param [Class] klass
    def included(klass)
      super
      Core::Multitone.__init__(klass)
    end
  end
end