class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.belongs_to :bid, foreign_key: true

      t.string :arrival_location, :null => false
      t.integer :arrival_status, default: 0
      t.integer :arrival_type, default: 0

      t.timestamps
    end
  end
end
