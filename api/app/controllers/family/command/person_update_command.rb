# Update a person(an adult or a child) command
class Family::Command::PersonUpdateCommand < Core::Command
  attr_accessor :id, :name, :photo_url, :model

  validates :id,        presence: true, 'Core::Validator::Exists' => ->(x) { { id: x.id, deleted_at: nil } }
  validates :name,      length: { maximum: 50 }
  validates :photo_url, length: { maximum: 100 }
  validates :photo_url, 'Core::Validator::Uri' => true

  # Runs command
  def execute
    person = model.where(id: id).first
    person.name = name unless name.nil?
    person.photo_url = photo_url unless photo_url.nil?
    person.save
    nil
  end

  # Gets the model to validate
  # @return [Class]
  def model_to_validate
    model
  end
end
