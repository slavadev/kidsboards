# Main methods for child and adult
module Family::PersonMethods
  # Generates a person
  # @param [User::User] user
  # @param [String] name
  # @param [String] photo_url
  def initialize(user, name, photo_url)
    super()
    self.user = user
    self.name = name
    self.photo_url = photo_url
  end

  def to_hash
    {
        id: id,
        name: name,
        photo_url: photo_url
    }
  end
end
