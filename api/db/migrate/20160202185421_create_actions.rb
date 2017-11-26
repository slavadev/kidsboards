class CreateActions < ActiveRecord::Migration[5.1]
  def change
    create_table :actions do |t|
      t.index    :id
      t.integer  :diff,     default: 0
      t.integer  :user_id,  index: true
      t.integer  :goal_id,  index: true
      t.integer  :adult_id, index: true
      t.datetime :created_at
    end
    add_foreign_key :actions, :users
    add_foreign_key :actions, :adults
    add_foreign_key :actions, :goals
  end
end
