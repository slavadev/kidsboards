require "#{Rails.root}/app/controllers/core/interpolations"
# Photo class
class File::Photo < ActiveRecord::Base
  belongs_to :user, inverse_of: :photos, class_name: 'User::User'

  has_attached_file :file,
                    url: '/images/:hash/:id/image.:extension',
                    hash_secret: 'asd1we1478yasdhbjhqbekhjqb',
                    use_timestamp: false

  validates_attachment_presence :file
  validates_attachment_content_type :file, content_type: %r{\Aimage/.*\Z}

  def initialize(user, file)
    super()
    self.user = user
    self.file = file
  end
end
