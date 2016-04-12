# Update a person(an adult or a child) command
class Family::Command::PersonUpdateCommand < Core::Command
  attr_accessor :id, :name, :photo_url, :model

  validates :id,        presence: true, 'Core::Validator::Exists' => ->(x) { x.model.not_deleted.find_by(id: x.id) }
  validates :id, 'Core::Validator::Owner' => ->(x) { x.model.find_by(id: x.id) }
  validates :name,      length: { maximum: 50 }
  validates :photo_url, length: { maximum: 100 }
  validates :photo_url, 'Core::Validator::Uri' => true

  # Runs command
  def execute
    person = model.find_by(id: id)
    person.name = name unless name.nil?
    person.photo_url = photo_url unless photo_url.nil?
    person.save
    nil
  end
end
