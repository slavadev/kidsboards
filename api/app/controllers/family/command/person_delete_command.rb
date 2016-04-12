# Delete a person(an adult or a child) command
class Family::Command::PersonDeleteCommand < Core::Command
  attr_accessor :id, :name, :photo_url, :model

  validates :id, presence: true, 'Core::Validator::Exists' => ->(x) { x.model.not_deleted.find_by(id: x.id) }
  validates :id, 'Core::Validator::Owner' => ->(x) { x.model.find_by(id: x.id) }

  # Runs command
  def execute
    person = model.find_by(id: id)
    person.delete
    nil
  end
end
