class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.index    :id
      t.string   :email, default: '', index: true
      t.string   :encrypted_password, default: ''
      t.string   :salt, default: ''
      t.datetime :confirmed_at
      t.string   :pin, default: '0000'
      t.timestamps
    end
  end
end
