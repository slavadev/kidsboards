# View a family command
class Family::Command::FamilyViewCommand < Core::Command
  # Runs command
  # @return [Hash]
  def execute
    user = User::User.get_user_by_token_code(token, User::Token::TYPE_LOGIN)
    family = user.family
    response = {}
    response['name'] = family.name
    response['photo_url'] = family.photo_url
    response['adults'] = get_persons user.adults.not_deleted
    response['children'] = get_persons user.children.not_deleted
    response
  end

  private

  # Gets persons
  # @param [Object] persons
  def get_persons(persons)
    response = []
    persons.each do |person|
      response.push(person.to_hash)
    end
    response
  end
end
