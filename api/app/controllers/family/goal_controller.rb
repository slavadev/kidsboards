# Goal controller
class Family::GoalController < ApplicationController
  before_action :authorize!, :get_child

  # Creates a new goal
  def create
    goal = Goal::Goal.create(goal_params)
    goal.user = @user
    goal.child = @child
    goal.current = 0
    goal.save!
    render json: { id: goal.id }
  end

  # Gets list of goals
  def index
    completed = params[:completed]
    goals = @child.goals.not_deleted
    unless completed.nil?
      goals = completed == 'true' ? goals.completed : goals.not_completed
    end
    @context = :index
    render json: goals
  end

  private

  # Loads the child from DB
  def get_child
    id = params[:id]
    @child = Family::Child.not_deleted.find(id)
    raise Core::Errors::ForbiddenError unless @child.user == @user
  end
end
