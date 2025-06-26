class RemoveCustomTimestampsFromContacts < ActiveRecord::Migration[8.0]
  def change
    remove_column :contacts, :createdAt, :datetime
    remove_column :contacts, :updatedAt, :datetime
    change_column_null :contacts, :linkPrecedence, false
  end
end
