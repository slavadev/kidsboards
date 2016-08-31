require "#{Rails.root}/app/infrastructure/core/interpolations"
# Photo class
# Fields:
#  [Integer]        id
#  [String]         file_file_name
#  [String]         file_content_type
#  [Integer]        file_file_size
#  [DateTime]       file_updated_at
#  [DateTime]       deleted_at
#  [DateTime]       created_at
#  [DateTime]       updated_at
#  [User::User]     user
#  [Object]         file
class Uploaded::Photo < ActiveRecord::Base
  extend Core::Deletable

  belongs_to :user, inverse_of: :photos, class_name: 'User::User'

  if Rails.env == 'aws'
    has_attached_file :file,
                      url: ':s3_domain_url',
                      styles: { :small => '400x400#' },
                      path: '/photos/:hash/:id/:style/image.:extension',
                      hash_secret: ENV['HASH_SECRET'],
                      use_timestamp: false,
                      :storage => :s3,
                      :s3_region => 'eu-west-1',
                      :s3_credentials => {:bucket => ENV['S3_BUCKET'],
                                          :access_key_id => ENV['S3_ACCESS_KEY_ID'],
                                          :secret_access_key => ENV['S3_SECRET_ACCESS_KEY']}
  else
    has_attached_file :file,
                      url: '/photos/:hash/:id/:style/image.:extension',
                      styles: { :small => '400x400#' },
                      path: ENV['UPLOAD_FOLDER'] + '/photos/:hash/:id/:style/image.:extension',
                      hash_secret: ENV['HASH_SECRET'],
                      use_timestamp: false
  end


  validates_attachment_presence :file
  validates_attachment_content_type :file, content_type: %r{\Aimage/.*\Z}

  # Generates a photo
  # @param [User::User] user
  # @param [Object] file
  # @return [Uploaded::Photo]
  def initialize(user, file)
    super()
    self.user = user
    self.file = file
  end
end
