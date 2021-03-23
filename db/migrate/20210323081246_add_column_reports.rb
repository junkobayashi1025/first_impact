class AddColumnReports < ActiveRecord::Migration[5.2]
  def up
    add_column :reports, :confirmed_date, :datetime
  end

  def down
    remove_column :reports, :confirmed_date, :datetime
  end
end
