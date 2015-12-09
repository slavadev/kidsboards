# Custom interpolations for Paperclip
module Paperclip::Interpolations
  # Returns a the attachment hash.
  def hash(attachment, style_name)
    attachment.hash_key(style_name).scan(/.{2}/).first(3).join('/'.freeze)
  end
end
