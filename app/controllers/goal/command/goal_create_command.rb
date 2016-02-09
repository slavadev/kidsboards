# Create a goal command
class Goal::Command::GoalCreateCommand < Core::Command
  attr_accessor :id, :name, :photo_url, :target

  validates :id, presence: true,
                 'Core::Validator::Exists' => ->(x) { { id: x.id, deleted_at: nil } }
  validates :name,      presence: true, length: { maximum: 50 }
  validates :photo_url, length: { maximum: 100 }
  validates :photo_url, 'Core::Validator::Uri' => true
  validates :target,    presence: true,
                        numericality: {
                          only_integer: true,
                          greater_than: 0,
                          less_than: 1000
                        }

  # Runs command
  # @return [Hash]
  def execute
    user = User::User.get_user_by_token_code(token, User::Token::TYPE_LOGIN)
    child = Family::Child.where(id: id).first
    goal = Goal::Goal.new(user, child, target, name)
    goal.photo_url = photo_url
    goal.save
    { id: goal.id }
  end

  # Gets the model to validate
  # @return [Class]
  def model_to_validate
    Family::Child
  end
end
