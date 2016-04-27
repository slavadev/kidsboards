# Contains methods to show families
class Family::Viewer::FamilyViewer
  # Sets all variables
  # @see Family::Viewer::PersonViewer
  def initialize
    @person_viewer = Family::Viewer::PersonViewer.new
  end

  # Converts attributes to hash
  # @param [ActiveRecord::Base] family
  # @return [Hash]
  def family_to_hash(family)
    {
      name: family.name,
      photo_url: family.photo_url,
      adults: family.adults.not_deleted,
      children: family.children.not_deleted
    }
  end

  private

  # Gets persons
  # @param [Object] persons
  def get_persons(persons)
    response = []
    persons.each do |person|
      response.push(@person_viewer.person_to_hash(person))
    end
    response
  end
end
