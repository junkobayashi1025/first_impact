class AddColumnDueReports < ActiveRecord::Migration[5.2]
  def up
    add_column :reports, :due,   :datetime
  end

  def down
    remove_column :reports, :due,   :datetime
  end
end
