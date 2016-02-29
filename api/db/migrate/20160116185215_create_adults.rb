class CreateAdults < ActiveRecord::Migration
  def change
    create_table :adults do |t|
      t.index      :id
      t.string     :name, default: ''
      t.string     :photo_url
      t.integer    :user_id, index: true
      t.datetime   :deleted_at
      t.timestamps null:false
    end
    add_foreign_key :adults, :users
  end
end
