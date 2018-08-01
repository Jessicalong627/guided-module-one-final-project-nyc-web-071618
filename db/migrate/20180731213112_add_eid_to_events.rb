class AddEidToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :eid, :string
  end
end
