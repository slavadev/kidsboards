# Photo controller
class Uploaded::PhotoController < ApplicationController
  before_action :authorize!
  before_action :get_photo, only: :delete

  # Creates a new image
  def create
    file = params[:file]
    photo = Uploaded::Photo.new(@user, file)
    photo.save!
    render json: photo
  end

  # Gets list of photos
  def index
    render json: @user.photos.not_deleted
  end

  # Deletes a photo
  def delete
    @photo.delete!
  end

  private

  # Loads the photo from DB
  def get_photo
    id = params[:id]
    @photo = Uploaded::Photo.not_deleted.find(id)
    raise Core::Errors::ForbiddenError unless @photo.user == @user
  end
end
