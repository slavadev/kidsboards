# Adult controller
class Family::AdultController < ApplicationController
  before_action :authorize!
  before_action :get_adult, only: [:update, :delete]

  # Creates an adult
  def create
    adult = Family::Adult.create(person_params)
    adult.user = @user
    adult.save!
    render json: { id: adult.id}
  end

  # Updates an adult
  def update
    @adult.update!(person_params)
  end

  # Deletes an adult
  def delete
    @adult.delete!
  end

  private

  # Loads an adult from DB
  def get_adult
    id = params[:id]
    @adult = Family::Adult.not_deleted.find(id)
    raise Core::Errors::ForbiddenError unless @adult.user == @user
  end
end
