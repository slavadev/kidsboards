class CreateTokens < ActiveRecord::Migration
  def change
    create_table :tokens do |t|
      t.index      :id
      t.string     :code, default: ''
      t.boolean    :is_expired
      t.integer    :token_type
      t.integer    :user_id, index: true
      t.timestamps null:false
    end
    add_foreign_key :tokens, :users
  end
end
