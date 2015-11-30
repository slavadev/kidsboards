require "#{Rails.root}/app/controllers/core/interpolations"

# Photo class
class File::Photo
  include Mongoid::Document
  include Mongoid::Paperclip

  field :deleted_at, type: DateTime, default: nil
  field :url, type: String, default: nil
  belongs_to :user, :inverse_of => :photos, :class_name => 'User::User'


  has_mongoid_attached_file :file,
                            #url: "/images/#{('a'..'z').to_a.shuffle[0,2].join}/#{('a'..'z').to_a.shuffle[0,2].join}/#{('a'..'z').to_a.shuffle[0,2].join}/:id/image.:extension",
                            url: '/images/:hash/:id/image.:extension',
                            hash_secret: 'asd1we1478yasdhbjhqbekhjqb',
                            use_timestamp: false

  validates_attachment_presence :file
  validates_attachment_content_type :file, content_type: /\Aimage\/.*\Z/

  def initialize(user, file)
    super()
    self.user = user
    self.file = file
    self.url = ENV['UPLOAD_HOST'] + self.file.url
  end
end