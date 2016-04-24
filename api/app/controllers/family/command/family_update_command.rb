# Update family command
class Family::Command::FamilyUpdateCommand < Core::Command
  attr_accessor :name, :photo_url
  attr_accessor :authorization_service

  validates :name,      length: { maximum: 50 }
  validates :photo_url, length: { maximum: 100 }
  validates :photo_url, 'Core::Validator::Uri' => true

  # Sets all variables
  # @param [Object] params
  # @see User::Service::AuthorizationService
  def initialize(params)
    super(params)
    @authorization_service = User::Service::AuthorizationService.new
  end

  # Runs command
  def execute
    user = @authorization_service.get_user_by_token_code(token)
    family = user.family
    family.name = name unless name.nil?
    family.photo_url = photo_url unless photo_url.nil?
    family.save
    nil
  end
end
