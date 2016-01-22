# Delete person(adult or child) command
class Family::Command::PersonDeleteCommand < Core::Command
  attr_accessor :id, :name, :photo_url, :model

  validates :id, presence: true, exists: lambda { |x| { id: x.id, deleted_at: nil } }

  # Run command
  def execute
    person = self.model.where(id: self.id).first
    person.deleted_at = DateTime.now.new_offset(0)
    person.save
    nil
  end

  # Get the model to validate
  # @return [Class]
  def model_to_validate
    self.model
  end
end
