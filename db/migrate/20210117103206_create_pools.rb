class CreatePools < ActiveRecord::Migration[6.0]
  def change
    create_table :pools do |t|
      t.integer :cg_id
      t.string :url
      t.string :user
      t.string :pass, default: 'x'
      t.integer :priority

      t.timestamps
    end
  end
end
