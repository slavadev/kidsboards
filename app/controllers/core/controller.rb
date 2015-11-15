# Common controller methods
class Core::Controller < ApplicationController
  # Checks validation and render 422 if there are some errors
  # @param [Core::Input] input
  # @return [Boolean]
  def check_validation(input)
    if input.valid?
      return true
    end
    render json:input.errors, status: 422
    return false
  end

end