# Contains methods to show adults and children
class Family::Viewer::PersonViewer
  # Sets all variables
  # @see Goal::Viewer::GoalViewer
  def initialize
    @goal_viewer = Goal::Viewer::GoalViewer.new
  end

  # Converts attributes to hash
  # @param [ActiveRecord::Base] person
  # @return [Hash]
  def person_to_hash(person)
    {
      id: person.id,
      name: person.name,
      photo_url: person.photo_url
    }
  end

  # Prepares goals to show to the user
  # @param [Array] child_goals
  # @return [Array]
  def child_goals_to_hash(child_goals)
    return [] if child_goals.nil?
    child_goals.inject([]) do |goals, goal|
      goals.push @goal_viewer.goal_to_hash(goal)
    end
  end
end
