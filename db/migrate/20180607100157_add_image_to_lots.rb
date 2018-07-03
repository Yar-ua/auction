class AddImageToLots < ActiveRecord::Migration[5.1]
  def change
    add_column :lots, :image, :string
  end
end
