# Update a person(an adult or a child) command
class Family::Command::PersonUpdateCommand < Core::Command
  attr_accessor :id, :name, :photo_url, :model
  attr_accessor :person_service

  validates :id, presence: true, 'Core::Validator::Exists' => ->(x) { x.person_service.find_not_deleted(x.id) }
  validates :id, 'Core::Validator::Owner' => ->(x) { x.person_service.find(x.id) }
  validates :name,      length: { maximum: 50 }
  validates :photo_url, length: { maximum: 100 }
  validates :photo_url, 'Core::Validator::Uri' => true

  # Sets all variables
  # @param [Object] params
  # @see Family::Service::PersonService
  def initialize(params)
    super(params)
    @person_service = Family::Service::PersonService.new(model)
  end

  # Runs command
  def execute
    person = @person_service.find(id)
    person.name = name unless name.nil?
    person.photo_url = photo_url unless photo_url.nil?
    @person_service.save!(person)
    nil
  end
end
