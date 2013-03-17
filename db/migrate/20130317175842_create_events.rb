class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :email, :name
      t.text :arguments, :category, :data
      t.datetime :happened_at

      t.timestamps
    end

    add_index :events, :email
    add_index :events, :happened_at
  end
end
