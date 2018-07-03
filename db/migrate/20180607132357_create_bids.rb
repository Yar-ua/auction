class CreateBids < ActiveRecord::Migration[5.1]
  def change
    create_table :bids do |t|
      t.belongs_to :lot, foreign_key: true
      t.belongs_to :user, foreign_key: true

      t.float :proposed_price, :null => false
      t.boolean :is_winner, :default => false

      t.timestamps
    end

    add_index :bids, :proposed_price
    add_index :bids, :is_winner
  end
end
