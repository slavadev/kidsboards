module Core::Deletable
  module ClassMethods
    def deleted
      self.not.where(deleted_at: nil)
    end

    def not_deleted
      where(deleted_at: nil)
    end
  end

  def delete
    self.deleted_at = DateTime.now.utc
    self.save
  end
end