class CreateAttachments < ActiveRecord::Migration[5.2]
  def change
    create_table :attachments do |t|
      t.string :image
      t.references :report, foreign_key: true

      t.timestamps
    end
  end
end
