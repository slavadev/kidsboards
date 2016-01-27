# Photo delete command
class File::Command::PhotoDeleteCommand < Core::Command
  attr_accessor :id

  validates :id, presence: true,
                 exists: ->(x) { { id: x.id, deleted_at: nil } }

  # Run command
  def execute
    photo = File::Photo.where(id: id, deleted_at: nil).first
    photo.deleted_at = DateTime.now.new_offset(0)
    photo.save
    nil
  end

  # Get the model to validate
  # @return [Class]
  def model_to_validate
    File::Photo
  end
end
