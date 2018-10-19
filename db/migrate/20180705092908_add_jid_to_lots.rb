class AddJidToLots < ActiveRecord::Migration[5.1]
  def change
    add_column :lots, :jid_in_process, :string
    add_column :lots, :jid_closed, :string
  end
end
