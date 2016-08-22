# Contains methods to work with family entities
class Family::FamilyRepository < Core::Repository
  # Sets all variables
  # @see Family::Family
  def initialize
    @model = Family::Family
  end
end
