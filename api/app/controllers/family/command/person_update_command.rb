# Update a person(an adult or a child) command
class Family::Command::PersonUpdateCommand < Core::Command
  attr_accessor :id, :name, :photo_url, :model
  attr_accessor :person_repository

  validates :id, presence: true, 'Core::Validator::Exists' => ->(x) { x.person_repository.find_not_deleted(x.id) }
  validates :id, 'Core::Validator::Owner' => ->(x) { x.person_repository.find(x.id) }
  validates :name,      length: { maximum: 50 }
  validates :photo_url, length: { maximum: 100 }
  validates :photo_url, 'Core::Validator::Uri' => true

  # Sets all variables
  # @param [Object] params
  # @see Family::Repository::PersonRepository
  def initialize(params)
    super(params)
    @person_repository = Family::Repository::PersonRepository.get(@model)
  end

  # Runs command
  def execute
    person = @person_repository.find(id)
    person.name = name unless name.nil?
    person.photo_url = photo_url unless photo_url.nil?
    @person_repository.save!(person)
    nil
  end
end
