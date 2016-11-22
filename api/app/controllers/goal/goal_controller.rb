# Goal controller
class Goal::GoalController < ApplicationController
  include ::Utilities
  before_action :authorize!, :get_goal
  before_action :get_adult, only: :points_update

  # Shows a goal
  def view
    render json: @goal
  end

  # Updates a goal
  def update
    @goal.update_attributes!(goal_params)
    render json: nil, status: 204
  end

  # Deletes a goal
  def delete
    @goal.delete!
    render json: nil, status: 204
  end

  # Adds or removes points
  def points_update
    diff = params[:diff]
    raise Core::Errors::BadRequest, 'Diff should be an Integer' unless is_integer?(diff)
    @goal.change_points(@adult, diff.to_i)
    @goal.save!
    render json: { current: @goal.current, target: @goal.target }
  end

  private

  # Returns params for goal update
  def goal_params
    params.permit(:name, :photo_url, :target)
  end

  # Loads the goal from DB
  def get_goal
    id = params[:id]
    @goal = Goal::Goal.not_deleted.find(id)
    raise Core::Errors::ForbiddenError unless @goal.user == @user
  end

  # Loads an adult from DB
  def get_adult
    adult_id = params[:adult_id]
    @adult = Family::Adult.not_deleted.find(adult_id)
    raise Core::Errors::ForbiddenError unless @adult.user == @user
  end
end
