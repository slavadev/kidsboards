# Update a goal command
class Goal::Command::GoalUpdateCommand < Core::Command
  attr_accessor :id, :name, :photo_url, :target

  validates :id,       presence: true,
                       'Core::Validator::Exists' => ->(x) { { id: x.id, deleted_at: nil } }
  validates :name,      length: { maximum: 50 }
  validates :photo_url, length: { maximum: 100 }
  validates :photo_url, 'Core::Validator::Uri' => true
  validates :target,    numericality: {
    only_integer: true,
    greater_than: 0,
    less_than: 1000
  }, allow_nil: true

  # Run command
  # @return [Hash]
  def execute
    goal = Goal::Goal.where(id: id).first
    goal.name = name unless name.nil?
    goal.photo_url = photo_url unless photo_url.nil?
    goal.target = target unless target.nil?
    goal.save
    nil
  end

  # Get the model to validate
  # @return [Class]
  def model_to_validate
    Goal::Goal
  end
end
