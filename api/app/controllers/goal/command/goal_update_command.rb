# Update a goal command
class Goal::Command::GoalUpdateCommand < Core::Command
  attr_accessor :id, :name, :photo_url, :target

  validates :id,       presence: true,
                       'Core::Validator::Exists' => ->(x) { Goal::Goal.not_deleted.find_by(id: x.id) }
  validates :id, 'Core::Validator::Owner' => ->(x) { Goal::Goal.find_by(id: x.id) }
  validates :name,      length: { maximum: 50 }
  validates :photo_url, length: { maximum: 100 }
  validates :photo_url, 'Core::Validator::Uri' => true
  validates :target,    numericality: {
    only_integer: true,
    greater_than: 0,
    less_than: 1000
  }, allow_nil: true

  # Runs command
  # @return [Hash]
  def execute
    goal = Goal::Goal.find_by(id: id)
    goal.name = name unless name.nil?
    goal.photo_url = photo_url unless photo_url.nil?
    goal.target = target unless target.nil?
    goal.save
    nil
  end
end
