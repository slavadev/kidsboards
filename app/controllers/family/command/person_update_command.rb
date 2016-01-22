# Update person(adult or child) command
class Family::Command::PersonUpdateCommand < Core::Command
  attr_accessor :id, :name, :photo_url, :model

  validates :id,        presence: true, exists: lambda { |x| { id: x.id, deleted_at: nil } }
  validates :name,      presence: true, length: { maximum: 50 }
  validates :photo_url, length: { maximum: 100 }
  validates :photo_url, uri: true

  # Run command
  def execute
    person = self.model.where(id: self.id).first
    person.name = name
    person.photo_url = photo_url
    person.save
    nil
  end

  # Get the model to validate
  # @return [Class]
  def model_to_validate
    self.model
  end
end
