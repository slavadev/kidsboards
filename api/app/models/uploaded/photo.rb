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
  include Core::Trait::Deletable

  belongs_to :user, inverse_of: :photos, class_name: 'User::User'

  # Options for file storage
  options = {
      :url           => '/photos/:hash/:id/:style/image.:extension',
      :styles        => { :small => '400x400#' },
      :path          => ENV['UPLOAD_FOLDER'] + '/photos/:hash/:id/:style/image.:extension',
      :hash_secret   => ENV['HASH_SECRET'],
      :use_timestamp => false
  }

  # Options for S3 and Minio
  if %w(aws production).include? Rails.env
    options.merge! ({
        :url            => ':s3_alias_url',
        :path           => '/photos/:hash/:id/:style/image.:extension',
        :storage        => :s3,
        :s3_protocol    => 'http',
        :s3_host_alias  => ENV['S3_HOST_NAME'],
        :s3_region      => 'eu-west-1',
        :s3_credentials => { :bucket            => ENV['S3_BUCKET'],
                             :access_key_id     => ENV['S3_ACCESS_KEY_ID'],
                             :secret_access_key => ENV['S3_SECRET_ACCESS_KEY'] }
    })
  end

  # Options only for Minio
  if Rails.env == 'production'
    options.merge! ({
        :s3_options     => {
          endpoint: ENV['S3_ENDPOINT'],
          force_path_style: true
        }
    })
  end

  has_attached_file :file, options

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
