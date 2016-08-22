# Contains methods to show families
class Family::FamilyPresenter < Core::Presenter
  # Converts attributes to hash
  # @param [Family::Family] family
  # @return [Hash]
  def family_to_hash(family)
    {
      name: family.name,
      photo_url: family.photo_url,
      adults: family.adults.not_deleted,
      children: family.children.not_deleted
    }
  end
end
