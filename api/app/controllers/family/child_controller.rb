# Child controller
class Family::ChildController < ApplicationController
  before_action :authorize!
  before_action :get_child, only: [:update, :delete]

  # Creates a child
  def create
    child = Family::Child.create(person_params)
    child.user = @user
    child.save!
    render json: { id: child.id}
  end

  # Updates a child
  def update
    @child.update!(person_params)
  end

  # Deletes a child
  def delete
    @child.delete!
  end

  private

  # Loads the child from DB
  def get_child
    id = params[:id]
    @child = Family::Child.not_deleted.find(id)
    raise Core::Errors::ForbiddenError unless @child.user == @user
  end
end
