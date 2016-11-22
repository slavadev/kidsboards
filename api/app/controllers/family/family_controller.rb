# Family controller
class Family::FamilyController < ApplicationController
  before_action :authorize!, :get_family

  # Updates family info
  def update
    @family.update!(family_params)
  end

  # Views family info
  def view
    render json: @family
  end

  private

  # Gets the family
  def get_family
    @family = @user.family
  end
end
