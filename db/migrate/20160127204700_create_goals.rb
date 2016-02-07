class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.index      :id
      t.string     :name, default: ''
      t.string     :photo_url
      t.integer    :target
      t.integer    :current
      t.integer    :user_id, index: true
      t.integer    :child_id, index: true
      t.datetime   :deleted_at
      t.timestamps
    end
    add_foreign_key :goals, :users
    add_foreign_key :goals, :children
  end
end
