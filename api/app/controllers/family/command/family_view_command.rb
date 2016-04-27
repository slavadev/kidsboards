# View a family command
class Family::Command::FamilyViewCommand < Core::Command
  # Sets all variables
  # @param [Object] params
  # @see User::Service::AuthorizationService
  # @see Family::Viewer::FamilyViewer
  def initialize(params)
    super(params)
    @authorization_service = User::Service::AuthorizationService.new
    @family_viewer = Family::Viewer::FamilyViewer.new
  end

  # Runs command
  # @return [Hash]
  def execute
    user = @authorization_service.get_user_by_token_code(token)
    family = user.family
    @family_viewer.family_to_hash(family)
  end
end
