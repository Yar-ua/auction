class CreateLots < ActiveRecord::Migration[5.1]
  def change
    create_table :lots do |t|
      t.belongs_to :user, foreign_key: true

      t.string :title
      t.string :description, :default => "null"
      t.float :current_price, :null => false
      t.float :estimated_price, :null => false
      t.datetime :lot_start_time, :null => false
      t.datetime :lot_end_time, :null => false

      t.timestamps
    end

    add_index :lots, :lot_start_time
    add_index :lots, :lot_end_time
  end
end
