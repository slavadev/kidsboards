# Delete methods
module Core::Trait::Deletable
  # Creates scopes for classes
  # @param [Class] klass
  def self.included(klass)
    klass.instance_eval do
      scope :deleted, -> { where.not(deleted_at: nil) }
      scope :not_deleted, -> { where(deleted_at: nil) }
    end
  end

  # Deletes an object
  def delete!
    self.deleted_at = DateTime.now.utc
    self.save!
  end
end
