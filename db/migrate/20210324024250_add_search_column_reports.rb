class AddSearchColumnReports < ActiveRecord::Migration[5.2]
  def up
    add_column :reports, :search_item, :integer, default: 0
  end

  def down
    remove_column :reports, :search_item, :integer, default: 0
  end
end
