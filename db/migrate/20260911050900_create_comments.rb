class CreateComments < ActiveRecord::Migration[8.1]
  def change
    create_table :comments do |t|
      t.references :project, null: false, foreign_key: true
      t.string :author_name
      t.text :body, null: false
      t.string :ip_address, null: false

      t.timestamps
    end
  end
end
