# Update family command
class Family::Command::FamilyUpdateCommand < Core::Command
  attr_accessor :name, :photo_url

  validates :name,      length: { maximum: 50 }
  validates :photo_url, length: { maximum: 100 }
  validates :photo_url, 'Core::Validator::Uri' => true

  # Sets all variables
  # @param [Object] params
  # @see User::Service::AuthorizationService
  # @see Family::Repository::FamilyRepository
  def initialize(params)
    super(params)
    @authorization_service = User::Service::AuthorizationService.new
    @family_repository = Family::Repository::FamilyRepository.new
  end

  # Rules for authorization
  # @return [Hash]
  def authorization_rules
    { token_type: :login }
  end

  # Runs command
  def execute
    user = @authorization_service.get_user_by_token_code(token)
    family = user.family
    family.name = name unless name.nil?
    family.photo_url = photo_url unless photo_url.nil?
    @family_repository.save!(family)
    nil
  end
end
