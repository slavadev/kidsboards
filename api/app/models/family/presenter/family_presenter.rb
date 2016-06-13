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
end
