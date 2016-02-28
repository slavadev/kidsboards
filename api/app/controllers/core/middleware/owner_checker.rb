# Class that checks that user is the owner
class Core::Middleware::OwnerChecker < Core::Middleware
  include Core::Authorization

  # Checks that user is the owner
  # @return [[Core::Command], [Object]]
  def call
    owner?
    self.next
  end

  private

  # Checks all tests
  # @raise Core::Errors::ForbiddenError
  def owner?
    rule = get_rule command
    return if rule.blank?
    return unless get_owner_param rule
    token = get_token command
    user = User::User.get_user_by_token_code(token.code, token.token_type)
    model = command.model_to_validate
    fail Core::Errors::ForbiddenError if model.where(user_id: user.id).first.nil?
  end
end
