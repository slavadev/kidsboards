# View a family command
class Family::Command::FamilyViewCommand < Core::Command
  # Run command
  def execute
    user = User::User.get_user_by_token_code(token, User::Token::TYPE_LOGIN)
    family = user.family
    response = {}
    response['name'] = family.name
    response['photo_url'] = family.photo_url
    response['adults'] = get_persons user.adults.where(deleted_at: nil)
    response['children'] = get_persons user.children.where(deleted_at: nil)
    response
  end

  # Get persons
  # @param [Object] persons
  def get_persons(persons)
    response = []
    persons.each do |person|
      response.push(get_person(person))
    end
    response
  end

  # Get person's attributes
  def get_person(person)
    {
      id: person.id,
      name: person.name,
      photo_url: person.photo_url
    }
  end
end
