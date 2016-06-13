# Contains methods to show adults and children
class Family::Presenter::PersonPresenter
  # Creates a presenter
  # @param [ActiveRecord::Base] person
  def initialize(person)
    @person = person
  end

  # Converts attributes to hash
  # @return [Hash]
  def person_to_hash
    {
      id: @person.id,
      name: @person.name,
      photo_url: @person.photo_url
    }
  end

  # Prepares goals to show to the user
  # @param [Boolean] is_completed
  # @return [Array]
  def child_goals_to_hash(is_completed)
    child_goals = Goal::Repository::GoalRepository.new.find_goals_by_child(@person, is_completed)
    return [] if child_goals.nil?
    child_goals.inject([]) do |goals, goal|
      goals.push Goal::Presenter::GoalPresenter.new(goal).goal_to_hash
    end
  end
end
