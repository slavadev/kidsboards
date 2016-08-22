# Delete methods
module Core::Deletable
  # Returns deleted objects
  # @return [Object]
  def deleted
    self.not.where(deleted_at: nil)
  end

  # Returns deleted objects
  # @return [Object]
  def not_deleted
    where(deleted_at: nil)
  end
end
