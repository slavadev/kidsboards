# Contains methods to show adults and children
class Family::PersonPresenter < Core::Presenter
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
  # @param [ActiveRecord::Base] person
  # @param [Boolean] is_completed
  # @return [Array]
  def child_goals_to_hash(person, is_completed)
    child_goals = Goal::GoalRepository.get.find_goals_by_child(person, is_completed)
    return [] if child_goals.nil?
    child_goals.inject([]) do |goals, goal|
      goals.push Goal::GoalPresenter.get.goal_to_hash(goal)
    end
  end
end
