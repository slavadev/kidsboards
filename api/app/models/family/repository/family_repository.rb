# Contains methods to work with family entities
class Family::Repository::FamilyRepository < Core::Repository
  # Sets all variables
  # @see Family::Family
  def initialize
    @model = Family::Family
  end
end
