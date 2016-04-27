# Contains methods to show goals
class Goal::Viewer::GoalViewer
  # Gets hash from goal
  # @param [Goal::Gaol] goal
  # @return [Hash]
  def goal_to_hash(goal)
    {
        id: goal.id,
        name: goal.name,
        photo_url: goal.photo_url,
        target: goal.target,
        current: goal.current
    }
  end

  # Gets hash with full info from goal
  # @param [Goal::Gaol] goal
  # @return [Hash]
  def goal_to_hash_with_full_info(goal)
    {
        id: goal.id,
        name: goal.name,
        photo_url: goal.photo_url,
        target: goal.target,
        current: goal.current,
        created_at: goal.created_at,
        actions: get_actions(goal)
    }
  end

  private

  # Gets goal's actions
  # @param [Goal::Gaol] goal
  # @return [Hash]
  def get_actions(goal)
    goal.actions.map do |action|
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
