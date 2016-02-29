class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.index      :id
      t.attachment :file
      t.integer    :user_id, index: true
      t.datetime   :deleted_at
      t.timestamps null:false
    end
    add_foreign_key :photos, :users
  end
end
