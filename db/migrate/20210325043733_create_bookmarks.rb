class CreateBookmarks < ActiveRecord::Migration[5.2]
  def change
    create_table :bookmarks do |t|
      t.references :report, foreign_key: true, null:false
      t.references :user,   foreign_key: true, null:false
      t.timestamps
    end
  end
end
