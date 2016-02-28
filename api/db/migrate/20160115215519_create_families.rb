class CreateFamilies < ActiveRecord::Migration
  def change
    create_table :families do |t|
      t.index     :id
      t.string    :name, default: ''
      t.string    :photo_url
      t.integer   :user_id, index: true
      t.timestamps
    end
    add_foreign_key :families, :users
  end
end
