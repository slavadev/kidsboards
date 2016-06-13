# Contains methods to show families
class Family::Presenter::FamilyPresenter
  # Creates a presenter
  # @param [Family::Family] family
  def initialize(family)
    @family = family
  end

  # Converts attributes to hash
  # @return [Hash]
  def family_to_hash
    {
      name: @family.name,
      photo_url: @family.photo_url,
      adults: @family.adults.not_deleted,
      children: @family.children.not_deleted
    }
  end

  private

  # Gets persons
  # @param [Object] persons
  def get_persons(persons)
    response = []
    persons.each do |person|
      response.push(Family::Presenter::PersonPresenter.new(person).person_to_hash)
    end
    response
  end
end
