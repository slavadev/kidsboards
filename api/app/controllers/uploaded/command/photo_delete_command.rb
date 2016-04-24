# Photo delete command
class Uploaded::Command::PhotoDeleteCommand < Core::Command
  attr_accessor :id
  attr_accessor :photo_service

  validates :id, presence: true,
                 'Core::Validator::Exists' => ->(x) { x.photo_service.find_not_deleted(x.id) }
  validates :id, 'Core::Validator::Owner' => ->(x) { x.photo_service.find(x.id) }

  # Sets all services
  # @param [Object] params
  # @see Uploaded::Service::PhotoService
  def initialize(params)
    super(params)
    @photo_service = Uploaded::Service::PhotoService.new
  end

  # Runs command
  def execute
    photo = @photo_service.find(id)
    @photo_service.delete(photo)
    nil
  end
end
