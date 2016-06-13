# Contains methods to show goals
class Goal::Presenter::GoalPresenter
  # Creates a presenter
  # @param [Goal::Gaol] goal
  def initialize(goal)
    @goal = goal
  end
  
  # Gets hash from goal
  # @return [Hash]
  def goal_to_hash
    {
      id: @goal.id,
      name: @goal.name,
      photo_url: @goal.photo_url,
      target: @goal.target,
      current: @goal.current
    }
  end

  # Gets hash with full info from goal
  # @return [Hash]
  def goal_to_hash_with_full_info
    {
      id: @goal.id,
      name: @goal.name,
      photo_url: @goal.photo_url,
      target: @goal.target,
      current: @goal.current,
      created_at: @goal.created_at,
      actions: get_actions
    }
  end

  private

  # Gets goal's actions
  # @return [Hash]
  def get_actions
    @goal.actions.map do |action|
      {
        adult: {
          id: action.adult.id,
          name: action.adult.name,
          photo_url: action.adult.photo_url
        },
        diff: action.diff,
        created_at: action.created_at
      }
    end
  end
end
