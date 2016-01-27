# Delete a person(an adult or a child) command
class Family::Command::PersonDeleteCommand < Core::Command
  attr_accessor :id, :name, :photo_url, :model

  validates :id, presence: true, exists: ->(x) { { id: x.id, deleted_at: nil } }

  # Run command
  def execute
    person = model.where(id: id).first
    person.deleted_at = DateTime.now.new_offset(0)
    person.save
    nil
  end

  # Get the model to validate
  # @return [Class]
  def model_to_validate
    model
  end
end
