# Photo delete command
class Uploaded::Command::PhotoDeleteCommand < Core::Command
  attr_accessor :id

  validates :id, presence: true,
                 'Core::Validator::Exists' => ->(x) { Uploaded::Photo.not_deleted.find_by(id: x.id) }
  validates :id, 'Core::Validator::Owner' => ->(x) { Uploaded::Photo.find_by(id: x.id) }

  # Runs command
  def execute
    photo = Uploaded::Photo.find_by(id: id)
    photo.delete
    nil
  end
end
