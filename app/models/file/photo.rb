# Photo class
class File::Photo
  include Mongoid::Document
  include Mongoid::Paperclip

  field :deleted_at, type: DateTime
  belongs_to :user, :inverse_of => :photos, :class_name => 'User::User'


  has_mongoid_attached_file :file,
                            url: "/images/#{('a'..'z').to_a.shuffle[0,2].join}/#{('a'..'z').to_a.shuffle[0,2].join}/#{('a'..'z').to_a.shuffle[0,2].join}/:id/image.:extension",
                            use_timestamp: false

  validates_attachment_presence :file
  validates_attachment_content_type :file, content_type: /\Aimage\/.*\Z/

  def initialize(user, file)
    super()
    self.user = user
    self.file = file
  end
end